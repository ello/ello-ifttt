require 'rails_helper'

RSpec.describe 'status', type: :request do

  it 'should return 200 if the channel key is valid' do
    get '/ifttt/v1/status',
        headers: { 'IFTTT-Channel-Key' => Rails.application.secrets.ifttt_channel_key }
    expect(response.status).to eq(200)
  end

  it 'should return 401 if the channel key is invalid' do
    get '/ifttt/v1/status',
        headers: { 'IFTTT-Channel-Key' => 'wrong' }
    expect(response.status).to eq(401)
  end
end
