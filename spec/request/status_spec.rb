require 'rails_helper'

RSpec.describe 'status', type: :request do
  before do
    get '/ifttt/v1/status'
  end

  it 'should return 200' do
    expect(response.status).to eq(200)
  end
end
