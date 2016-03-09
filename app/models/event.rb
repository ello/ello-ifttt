class Event < ApplicationRecord

  validates_presence_of :owner_id, :action_taken_by_id, :kind, :created_at, :payload
end
