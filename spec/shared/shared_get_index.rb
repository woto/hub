# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'shared get_index', focus: true do |role, permission|
  it "#{permission} for the role: #{role}" do
    case role
    when :user, :manager, :admin
      user = create(:user, role: role)
      sign_in(user)
    when :guest
      nil
    else
      raise 'wrong role'
    end

    get path

    case permission
    when :ok
      expect(response).to have_http_status(:ok)
    when :unauthorized
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    when :forbidden
      expect(response).to have_http_status(:forbidden)
    else
      raise 'wrong permission'
    end
  end
end
