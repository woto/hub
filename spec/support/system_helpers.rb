# frozen_string_literal: true

module SystemHelpers
  # TODO: it's a dirty way to check if user is authenticated
  def expect_authenticated
    expect(page).to have_selector('#authenticated div', text: "##{user.id}")
  end

  def expect_dashboard
    expect(page).to have_current_path('/en/dashboard')
  end
end
