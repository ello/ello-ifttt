require_relative '../../lib/sidekiq/interactor'

class CreateEventFromStream < Sidekiq::Interactor

  def call(_c)
    if respond_to?(context.kind)
      send context.kind
    end
  end

  def post_was_created
    Event.create!(
      kind: context.kind,
      owner_id: context.record['author']['id'],
      action_taken_by_id: context.record['author']['id'],
      payload: context.record,
      created_at: Time.at(context.record['post']['created_at'])
    )
  end

  def post_was_loved
    Event.create!(
      kind: context.kind,
      owner_id: context.record['author']['id'],
      action_taken_by_id: context.record['lover']['id'],
      payload: context.record,
      created_at: Time.at(context.record['loved_at'])
    )
  end
end
