# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Advertisers', type: :system do
  it_behaves_like 'shared_table', Advertiser
end
