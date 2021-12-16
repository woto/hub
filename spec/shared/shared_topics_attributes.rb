# frozen_string_literal: true

require 'rails_helper'

shared_examples '#topics_attributes=' do |_parameter|
  def do_the_action
    subject.update(topics_attributes: params)
  end

  context 'when does not pass topic1 and topic1 is linked to the subject' do
    let(:params) { [topic2.title] }

    it 'unlinks topic1 but does not remove it' do
      do_the_action
      expect(subject.topics).to contain_exactly(topic2)
      expect(topic1.reload).not_to be_nil
    end
  end

  context 'when passed new topic which is not exists yet' do
    let(:params) { [topic1.title, topic2.title, 'new topic'] }

    it 'creates new linked topic' do
      expect do
        do_the_action
        expect(subject.topics).to contain_exactly(topic1, topic2, Topic.find_by(title: 'new topic'))
      end.to change(Topic, :count).by(1)
    end
  end

  context 'when passed topic is not liked yet to the subject' do
    let!(:topic) { create(:topic) }

    let(:params) { [topic1.title, topic2.title, topic.title] }

    it 'links topic to the subject' do
      expect do
        do_the_action
        expect(subject.topics).to contain_exactly(topic1, topic2, topic)
      end.not_to change(Topic, :count)
    end
  end

  context 'when passed topics already linked to the subject' do
    let(:params) { [topic1.title, topic2.title] }

    it 'does not relink it again' do
      expect do
        do_the_action
        expect(subject.topics).to contain_exactly(topic1, topic2)
      end.not_to change(Topic, :count)
    end
  end
end
