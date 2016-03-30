require 'rails_helper'

describe PushEventToIftttRealtime do
  subject { described_class }
  let(:event) do
    Event.create!(
      kind: 'post_loved_at',
      owner_id: 'test-user-1',
      action_taken_by_id: 'test-user-2',
      payload: { doesnt: 'matter' },
      created_at: Time.now
    )
  end
  let(:response) { Net::HTTPSuccess.new('', '', '') }
  let(:fake_http) { double(:fake_http, 'use_ssl=': true, request: response) }
  before { allow(Net::HTTP).to receive(:new) { fake_http } }
  before { RegisteredUser.create!(user_id: event.owner_id) }

  before { subject.perform(event: event) }
  it 'should make a request to ifttt' do
    expect(fake_http).to have_received(:request)
  end
end
