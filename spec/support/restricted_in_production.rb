# frozen_string_literal: true

RSpec.shared_examples 'restricted in production' do |path|
  xit 'Is not intended to run in production' do
    string_inquirer = ActiveSupport::StringInquirer.new('production')
    allow(Rails).to receive(:env).and_return(string_inquirer)
    get path
    expect(response).to have_http_status(:forbidden)
  end
end
