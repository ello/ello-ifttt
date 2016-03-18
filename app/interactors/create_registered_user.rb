require_relative '../../lib/sidekiq/interactor'

class CreateRegisteredUser < Sidekiq::Interactor
  def call(context)
    RegisteredUser.where(user_id: context[:user_id]).first_or_create!
  rescue ActiveRecord::RecordNotUnique
    # Already created? Cool. We just want to ensure it is created.
  end
end
