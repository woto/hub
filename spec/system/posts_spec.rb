# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts page' do
  it_behaves_like 'shared_table', Post, true
end
