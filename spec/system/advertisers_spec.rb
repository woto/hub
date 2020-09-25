# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Advertisers page' do
  it_behaves_like 'shared_table', Advertiser
end
