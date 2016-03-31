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

  it 'should create a user' do
    expect(RegisteredUser.count).to eq(1)
    expect(RegisteredUser.first.user_id).to eq('test-user-1')
    expect(RegisteredUser.first.created_at.year).to eq(2015)
  end

  it 'should create 6 events' do
    expect(Event.count).to eq(6)
    expect(Event.pluck(:created_at).map(&:year).uniq).to eq([2016])
    expect(Event.pluck(:owner_id)).to include('test-user-1')
    expect(Event.pluck(:action_taken_by_id)).to include('test-user-1')
  end

end
