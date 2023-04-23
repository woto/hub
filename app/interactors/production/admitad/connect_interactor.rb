# frozen_string_literal: true

require 'capybara/dsl'

module Production
  module Admitad
    class ConnectInteractor
      include Capybara::DSL
      include ApplicationInteractor

      def call
        Capybara.default_driver = :selenium_chrome
        loop do
          sleep 5
          buttons = all('button.cta.offer-tooltip__target.offer__connect-cta.cta_accent.ng-star-inserted:not(:disabled)')
          buttons.each do |button|
            sleep 1
            button.hover
            sleep 1
            button.click
            sleep 1
            click_on('Принять')
          end

          buttons = all('button.cta.offer-tooltip__target.offer__connect-cta.cta_primary.ng-star-inserted:not(:disabled)')
          buttons.each do |button|
            sleep 1
            button.hover
            sleep 1
            button.click
            click_on('Принять')
            sleep 1
            find('button.admitad-dialog__close.ng-star-inserted[title="Закрыть"]').click
          end
          find('a[rel="next"]').click
        end
      end
    end
  end
end
