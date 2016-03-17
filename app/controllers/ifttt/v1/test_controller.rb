class Ifttt::V1::TestController < ApplicationController
  before_action :validate_channel_key

  def setup
    create_events_as_needed!
    render json: {
      data: {
        accessToken: token_for_test_user,
        samples: {
          triggers: {
            submitted_new_post: {},
            loved_a_post: {},
          },
          actions: {
            create_post: {}
          }
        }
      }
    }
  end

  private

  def token_for_test_user
    JWT.encode(jwt_payload,
               OpenSSL::PKey::RSA.new(ENV['JWT_PRIVATE_KEY']),
               'RS512')
  end

  def jwt_payload
    {
      iss: 'Ello, PBC',
      iat: Time.now.to_i,
      jti: SecureRandom.hex,
      exp: 2.hours.from_now,
      data: {
        analytics_id: 'abc123',
        user_id: 'test-user-1',
        username: 'testuser'
      }
    }
  end

  def create_events_as_needed!
    3.times do |i|

      # 3 Posts created by test user
      Event.where(
        owner_id: 'test-user-1',
        action_taken_by_id: 'test-user-1',
        kind: 'post_was_created',
        created_at: Time.new(2016, 01, i+1)
      ).first_or_create(
        payload: {
          post: {
            id: "test-post-#{i+1}",
            url: "https://ello.co/test-user-1/posts/test-post-#{i+1}"
          }
        }
      )

      # 3 Loves by test user
      Event.where(
        owner_id: "test-user-#{i+10}",
        action_taken_by_id: 'test-user-1',
        kind: 'post_was_loved',
        created_at: Time.new(2016, 01, i+1)
      ).first_or_create!(
        payload: {
          loved_at: Time.new(2016, 01, i+1),
          post: {
            id: "test-post-#{i}",
            url: "https://ello.co/test-user-1/posts/test-post-#{i}"
          }
        }
      )
    end
  end
end
