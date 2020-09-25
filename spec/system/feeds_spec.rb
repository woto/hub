# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feeds page' do
  it_behaves_like 'shared_table', Feed
end
