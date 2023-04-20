# frozen_string_literal: true

require 'rails_helper'

describe Roastme::TinderController, type: :system do
  before do
    first, second, third = create_list(:entity, 3)
    allow(Entity).to receive(:order).with('RANDOM()').and_return([first], [second], [third])
    visit '/tinder'
  end

  def cards_ids
    page.all('a', text: 'перейти', count: 2).pluck(:href)
  end

  def tinder
    first("[data-test-id='tinder']")
  end

  def action(threshold)
    page.driver.browser.action.move_to(tinder.native, 0, 0)
        .click_and_hold.move_to(tinder.native, threshold, 0).release.perform
  end

  it 'does not swipe away if dragged a little bit' do
    expect { action(50) }.not_to(change { cards_ids })
    expect(Entity).to have_received(:order).twice
  end

  it 'swipes away if dragged more' do
    expect { action(150) }.to(change { cards_ids })
    expect(Entity).to have_received(:order).thrice
  end
end
