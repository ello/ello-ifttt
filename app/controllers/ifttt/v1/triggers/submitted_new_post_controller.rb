class Ifttt::V1::Triggers::SubmittedNewPostController < ApplicationController
  before_action :require_registered_user

  def index
    render json: { data: events.map { |e| to_json(e) } }
  end

  private

  def events
    Event.where('created_at >= ?', current_registered_user.created_at).where(
      kind:  'post_was_created',
      owner_id: user_id,
    ).order('created_at DESC').limit(limit)
  end

  def to_json(event)
    {
      post_url: event.payload['post']['url'],
      created_at: event.created_at.to_time.iso8601,
      meta: {
        id: event.id,
        timestamp: event.created_at.to_i
      }
    }
  end

  def limit
    params[:limit] || 50
  end
end
