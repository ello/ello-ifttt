require 'rails_helper'

RSpec.describe 'test/setup', type: :request do

  let(:response_json) { JSON.parse(response.body) }

  before do
    post '/ifttt/v1/test/setup',
         headers: { 'IFTTT-Channel-Key' => Rails.application.secrets.ifttt_channel_key }
  end

  it 'should return a valid access token' do
    expect(response.status).to eq(200)
    expect(response_json['data']['accessToken']).to be_present
  end

  it 'should create 6 events' do
    expect(Event.count).to eq(6)
  end

end
