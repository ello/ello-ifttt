class CreateEventFromStream
  include Interactor

  def call
    Event.create!(
      kind: context.kind,
      owner_id: context.record['author']['id'],
      action_taken_by_id: action_taken_by_id,
      payload: context.record,
      created_at: Time.at(created_at)
    )
  end

  private

  def action_taken_by_id
    case context.kind
    when 'post_was_created'
      context.record['author']['id']
    when 'post_was_loved'
      context.record['lover']['id']
    end
  end

  def created_at
    case context.kind
    when 'post_was_created'
      context.record['post']['created_at']
    when 'post_was_loved'
      context.record['loved_at']
    end
  end
end
