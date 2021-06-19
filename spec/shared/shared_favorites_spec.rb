# frozen_string_literal: true

require 'rails_helper'

shared_examples 'favorites_initial_starred' do
  let!(:starred) { raise 'is starred' }

  context 'when element added to favorites' do
    it 'is starred' do
      within('section.page') do
        button = find_button(starred)
        expect(button).to match_css('.active')
        button.ancestor('.z-index-decreased')
        button.click
        expect(button).to match_css('.active.show')
        button.ancestor('.z-index-increased')
        # TODO
        # within(button.ancestor('.z-index-increased')) do
        #   dropdown_list_check
        # end
      end
    end
  end
end


shared_examples 'favorites_initial_unstarred' do
  let!(:unstarred) { raise 'is not starred' }

  context 'when element is not added to favorites' do
    it 'is not starred' do
      within('section.page') do
        button = find_button(unstarred)
        expect(button).to not_match_css('.active')
      end
    end
  end

end

