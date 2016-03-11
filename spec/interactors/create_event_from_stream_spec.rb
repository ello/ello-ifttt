require 'rails_helper'

describe CreateEventFromStream do

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
        'loved_at'=> loved_at
      }
    end

    let(:kind) { 'post_was_loved' }

    it 'should create an event' do
      described_class.call(kind: kind, record: record)
      event = Event.last
      expect(event).to be_present
      expect(event.kind).to eq kind
      expect(event.payload).to eq record
      expect(event.created_at).to be_within(0.01).of(Time.zone.at(loved_at))
      expect(event.action_taken_by_id).to eq '42'
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

    it 'should create an event' do
      described_class.call(kind: kind, record: record)
      event = Event.last
      expect(event).to be_present
      expect(event.kind).to eq kind
      expect(event.payload).to eq record
      expect(event.created_at).to be_within(0.01).of(Time.zone.at(post_created_at))
      expect(event.action_taken_by_id).to eq '42'
    end
  end
end
