# frozen_string_literal: true

module SystemHelpers
  def expect_authenticated
    expect(page).to have_selector('.authenticated_component')
  end

  def expect_unauthenticated
    expect(page).to have_selector('.unauthenticated_component')
  end

  def expect_dashboard
    expect(page).to have_current_path('/ru/dashboard')
  end
end
