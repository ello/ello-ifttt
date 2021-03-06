require_relative '../../lib/sidekiq/interactor'

class CreateEventFromStream < Sidekiq::Interactor

  IMAGE_PROCESSING_DELAY = (ENV['IMAGE_PROCESSING_DELAY'] || '120').to_i.seconds

  def call(_c)
    if respond_to?(context.kind) && !private_user? && for_registered_user?
      event = send context.kind
      PushEventToIftttRealtime.perform_in(IMAGE_PROCESSING_DELAY, event: event)
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

  private

  def for_registered_user?
    RegisteredUser.where(user_id: impacted_users).exists?
  end

  def private_user?
    context.record['author']['is_private']
  end

  def impacted_users
    [author_id, lover_id].compact
  end

  def author_id
    context.record['author']['id']
  end

  def lover_id
    context.record['lover'] ? context.record['lover']['id'] : nil
  end
end
