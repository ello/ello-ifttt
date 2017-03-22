require 'rails_helper'

describe CreateEventFromStream do

  before do
    allow(PushEventToIftttRealtime).to receive(:perform_in)
  end

  context 'for a registered user' do
    before { RegisteredUser.create!(user_id: '42') }

    context 'post was loved' do
      let(:loved_at) { 1_457_645_629.507 }
      let(:record) do
        {
          'post' => {
            'id' => '11',
            'created_at' => 1_456_423_740.374,
            'body' => '[{"kind":"text","data":"The TCP application is down!"}]',
            'nsfw' => false,
            'url' => 'https://ello.co/odinspy/posts/11'
          },
          'author' => {
            'id' => '11',
            'username' => 'odinspy',
            'url' => 'https://ello.co/odinspy'
          },
          'lover' => {
            'id' => '42',
            'username' => 'archer',
            'url' => 'https://ello.co/archer'
          },
          'loved_at' => loved_at
        }
      end

      let(:kind) { 'post_was_loved' }

      before { described_class.perform(kind: kind, record: record) }

      it 'should create an event' do
        event = Event.last
        expect(event).to be_present
        expect(event.kind).to eq kind
        expect(event.payload).to eq record
        expect(event.created_at).to be_within(0.01).of(Time.zone.at(loved_at))
        expect(event.action_taken_by_id).to eq '42'
      end

      it 'should push event to realtime interactor' do
        expect(PushEventToIftttRealtime).to have_received(:perform_in).with(anything(), event: an_instance_of(Event))
      end
    end

    context 'post was created' do
      let(:post_created_at) { 1_457_645_607.709 }
      let(:record) do
        {
          'post' => {
            'id' => '60',
            'created_at' => post_created_at,
            'body' => '[{"kind":"text","data":"and another"}]',
            'nsfw' => true,
            'url' => 'https://ello.co/archer/posts/60'
          },
          'author' => {
            'id' => '42',
            'username' => 'archer',
            'url' => 'https://ello.co/archer'
          }
        }
      end

      let(:kind) { 'post_was_created' }

      before { described_class.perform(kind: kind, record: record) }

      it 'should create an event' do
        event = Event.last
        expect(event).to be_present
        expect(event.kind).to eq kind
        expect(event.payload).to eq record
        expect(event.created_at).to be_within(0.01).of(Time.zone.at(post_created_at))
        expect(event.action_taken_by_id).to eq '42'
      end

      it 'should push event to realtime interactor' do
        expect(PushEventToIftttRealtime).to have_received(:perform_in).with(anything(), event: an_instance_of(Event))
      end
    end

    context 'unknown event' do
      let(:record) { {} }
      let(:kind) { 'unknown_kind' }

      it 'should not do anything' do
        described_class.perform(kind: kind, record: record)

        expect(Event.count).to eq 0
      end
    end

    context 'private user' do
      let(:record) do
        {
          'post' => {
            'id' => '60',
            'created_at' => 2.minutes.ago,
            'body' => '[{"kind":"text","data":"and another"}]',
            'nsfw' => true,
            'url' => 'https://ello.co/archer/posts/60'
          },
          'author' => {
            'id' => '42',
            'username' => 'archer',
            'url' => 'https://ello.co/archer',
            'is_private' => true
          }
        }
      end

      let(:kind) { 'post_was_created' }

      it 'should not do anything' do
        described_class.perform(kind: kind, record: record)

        expect(Event.count).to eq 0
      end
    end
  end

  context 'user is not registered' do
    context 'post was created' do
      let(:post_created_at) { 1_457_645_607.709 }
      let(:record) do
        {
          'post' => {
            'id' => '60',
            'created_at' => post_created_at,
            'body' => '[{"kind":"text","data":"and another"}]',
            'nsfw' => true,
            'url' => 'https://ello.co/archer/posts/60'
          },
          'author' => {
            'id' => '42',
            'username' => 'archer',
            'url' => 'https://ello.co/archer'
          }
        }
      end

      let(:kind) { 'post_was_created' }

      before { described_class.perform(kind: kind, record: record) }

      it 'should not do anything' do
        expect(Event.count).to eq 0
      end
    end
  end
end
