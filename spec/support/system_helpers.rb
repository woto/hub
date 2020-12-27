# frozen_string_literal: true

module SystemHelpers
  def expect_authenticated
    expect(page).to have_selector('.capybara-authenticated')
  end

  def expect_unauthenticated
    expect(page).to have_selector('.capybara-unauthenticated')
  end

  def expect_dashboard
    expect(page).to have_current_path('/ru/dashboard')
  end
end
