require 'rails_helper'

RSpec.describe 'Fetching new post triggers', type: :request do

  let(:response_json) { JSON.parse(response.body) }
  let(:jwt_token) do
    JWT.encode(jwt_payload,
               OpenSSL::PKey::RSA.new(ENV['JWT_PRIVATE_KEY']),
               'RS512')
  end

  let(:jwt_payload) do
    {
      iss: 'Ello, PBC',
      iat: Time.now.to_i,
      jti: SecureRandom.hex,
      exp: exp.to_i,
      data: {
        analytics_id: 'abc123',
        username: 'archer',
        id: 1
      }
    }
  end

  describe 'with a valid JWT token' do
    let(:exp) { 2.hours.from_now }
    let(:params) { { limit: 10 } }

    let!(:pc1) do
      Event.create!(
        owner_id: '1',
        payload: { post: { id: 1, url: 'https://ello.co/archer/posts/1' } },
        created_at: 2.hours.ago,
        kind: 'post_was_created',
        action_taken_by_id: '1'
      )
    end
    let!(:pc2) do
      Event.create!(
        owner_id: '1',
        payload: { post: { id: 2, url: 'https://ello.co/archer/posts/2' } },
        created_at: 1.hours.ago,
        kind: 'post_was_created',
        action_taken_by_id: '1'
      )
    end
    let!(:pl1) do
      Event.create!(
        owner_id: '1',
        payload: { post: { id: 1, url: 'https://ello.co/archer/posts/1' } },
        created_at: 1.hours.ago,
        kind: 'post_was_loved',
        action_taken_by_id: '2'
      )
    end
    let!(:pc3) do
      Event.create!(
        owner_id: '2',
        payload: { post: { id: 3, url: 'https://ello.co/lana/posts/3' } },
        created_at: 1.hours.ago,
        kind: 'post_was_created',
        action_taken_by_id: '2'
      )
    end

    before do
      post '/ifttt/v1/triggers/submitted_new_post',
           params: params,
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{jwt_token}" }
    end

    it 'returns a JSON hash of the most recent events by the jwt user' do
      expect(response.status).to eq(200)
      expect(response_json['data'].size).to eq 2
      expect(response_json['data'].first).to eq(
        'post_url' => 'https://ello.co/archer/posts/2',
        'created_at' => pc2.created_at.as_json,
        'meta' => {
          'id' => pc2.id,
          'timestamp' => pc2.created_at.to_i
        }
      )
    end
  end
end
