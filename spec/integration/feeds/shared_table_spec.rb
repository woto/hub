# frozen_string_literal: true

require 'rails_helper'

describe Tables::FeedsController, type: :system do
  describe 'shared_table' do
    it_behaves_like 'shared_table' do
      let(:objects) { create_list(singular, 11) }
      let(:plural) { 'feeds' }
      let(:singular) { 'feed' }
    end
  end
end
