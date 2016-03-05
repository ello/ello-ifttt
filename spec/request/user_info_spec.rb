require 'rails_helper'

RSpec.describe 'Fetching user info', type: :request do

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
        username: 'archer'
      }
    }
  end

  before do
    get '/ifttt/v1/user/info', headers: { 'HTTP_AUTHORIZATION' => "Bearer #{jwt_token}" }
  end

  describe 'with a valid JWT token' do
    let(:exp) { 2.hours.from_now }

    it 'returns a JSON hash of user info' do
      expect(response.status).to eq(200)
      expect(response_json).to eq(
        'data' => {
          'name' => 'archer',
          'id' => 'archer',
          'url' => 'https://ello.co/archer'
        }
      )
    end
  end

  describe 'with an expired JWT token' do
    let(:exp) { 2.hours.ago }

    it 'returns a 401 with an empty body' do
      expect(response.status).to eq(401)
      expect(response.body).to be_empty
    end
  end

end
