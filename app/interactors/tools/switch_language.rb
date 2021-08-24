# frozen_string_literal: true

module Tools
  class SwitchLanguage
    include ApplicationInteractor

    def call
      context.object = if I18n.available_locales.map(&:to_s).include?(context.subdomains.first)
                         { host: context.host.sub(context.subdomains.first, context.locale.to_s) }
                       else
                         { locale: context.locale }
                       end
    end
  end
end
