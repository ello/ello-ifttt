module Sidekiq
  class Interactor
    include ::Interactor
    include Sidekiq::Worker

    class << self
      alias_method :perform, :call

      def perform_async(kwargs)
        client_push('class' => self, 'args' => serialize(kwargs))
      end

      def perform_in(interval, kwargs)
        time = Time.now.to_f + interval.to_f

        perform_at(time, kwargs)
      end

      def perform_at(time, kwargs)
        if time.to_f <= Time.now.to_f
          perform_async(kwargs)
        else
          client_push(
            'class' => self,
            'args' => serialize(kwargs),
            'at' => time.to_f
          )
        end
      end

      private

      def serialize(kwargs)
        [Sidekiq::RecordArguments.new(kwargs).serialize]
      end
    end

    def perform(kwargs)
      record = Sidekiq::RecordArguments.new(kwargs).deserialize

      if record
        self.class.call(record)
      end
    end

    def run!
      with_hooks do
        call(context.to_h)
        context.called!(self)
      end
    rescue
      context.rollback!
      raise
    end

    def call(*)
      raise NotImplementedError, "Expected #{self.class} to implement #{__method__}"
    end

    private

    # todo: remove this and watch the world burn -- and then clean it up.
    def method_missing(method, *args)
      context.send(method, *args)
    end
  end

  class RecordArguments

    def initialize(params)
      unless params.is_a?(Hash)
        raise ArgumentError, "Named parameters required: #{params.inspect}"
      end

      @params = params
    end

    def serialize
      params.each do |key, value|
        if serialize?(value)
          params[key] = serialize_value(value)
        end
      end

      params
    end

    def deserialize
      params.each do |key, value|
        if deserialize?(value)
          params[key] = deserialize_value(value)
        end
      end

      params
    rescue ActiveRecord::RecordNotFound
      nil
    end

    private

    attr_reader :params

    def serialize?(value)
      value.is_a?(ActiveRecord::Base)
    end

    def serialize_value(value)
      { 'active_record' => { 'id' => value.id, 'class' => value.class.name } }
    end

    def deserialize?(value)
      value.is_a?(Hash) && value.has_key?('active_record')
    end

    def deserialize_value(value)
      record_id = value['active_record']['id']
      record_class = value['active_record']['class']

      "::#{record_class}".constantize.find(record_id)
    end

  end
end
