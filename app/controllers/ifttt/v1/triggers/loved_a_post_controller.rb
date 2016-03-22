class Ifttt::V1::Triggers::LovedAPostController < ApplicationController
  def index
    render json: { data: events.map { |e| to_json(e) } }
  end

  private

  def events
    Event.where(
      kind: 'post_was_loved',
      action_taken_by_id: user_id,
    ).order('created_at DESC').limit(limit)
  end

  def to_json(event)
    {
      post_url: event.payload['post']['url'],
      loved_at: event.created_at.to_time.iso8601,
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
