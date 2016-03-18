require_relative '../../lib/sidekiq/interactor'
require 'net/http'

class PushEventToIftttRealtime < Sidekiq::Interactor
  HOST = URI('https://realtime.ifttt.com')

  def call(_c)
    if user_is_registered?
      send_to_ifttt
    end
  end

  private

  def event
    context[:event]
  end

  def user_is_registered?
    RegisteredUser.
      where(user_id: [event.owner_id, event.action_taken_by_id]).
      exists?
  end

  def send_to_ifttt
    case request('/v1/notifications', json_body)
    when Net::HTTPFound, Net::HTTPSuccess, Net::HTTPCreated
      Sidekiq.logger.info "Successfully notified IFTTT for user id #{event.owner_id} and #{event.action_taken_by_id}"
    else
      Sidekiq.logger.warn "Failed to notify IFTTT for user id #{event.owner_id} and #{event.action_taken_by_id}"
      fail "Error accessing notification service (#{response.code}): #{response.body}"
    end
  end

  def request(path, body)
    request = Net::HTTP::Post.new(path)
    request.add_field 'Content-Type', 'application/json'
    request.add_field 'Accept', 'application/json'
    request.add_field 'IFTTT-Channel-key', Rails.application.secrets.ifttt_channel_key
    request.body = body.to_json
    http.request(request)
  end

  def json_body
    {
      data: [
        { user_id: event.owner_id },
        { user_id: event.action_taken_by_id }
      ]
    }
  end

  def http
    http = Net::HTTP.new(HOST.host, HOST.port)
    http.use_ssl = true
    http
  end
end
