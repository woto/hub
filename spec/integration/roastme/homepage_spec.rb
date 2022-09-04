# frozen_string_literal: true

require 'rails_helper'

describe Roastme::HomepageController, type: :system do
  # NOTE: non deterministic test. May fail

  before do
    create_list(:entity, 10)
    switch_domain('mentions.lvh.me') do
      visit roastme_root_path
    end
  end

  def cards_ids
    all("[data-test-class='card']", count: 2) { |el| el['data-entity-id'] =~ /\d+/ }.map { |el| el['data-entity-id'] }
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
  end

  it 'swipes away if dragged more' do
    expect { action(150) }.to(change { cards_ids })
  end
end
