# frozen_string_literal: true

module ApplicationHelper
  def serialize_language_attributes
    {
      title: t('header.menu.language'),
      languages:
        I18n.available_locales.map do |locale|
          {
            title: system_locale_to_human(locale),
            url: path_for_switch_language(locale, Current.realm&.kind) ||
              url_for(
                Tools::SwitchLanguageInteractor.call(
                  subdomains: request.subdomains,
                  host: request.host,
                  locale:
                ).object
              )
          }
        end
    }
  end

  def resolve_widgetable_partial(widget, purpose: 'articles')
    case widget.widgetable.class.name.underscore
    when 'widgets/simple'
      "widgets/simples/#{purpose}/widget"
    else
      raise 'Unexpected widgetable class'
    end
  end

  def system_locale_to_human(locale)
    Rails.application.config.global[:locales].find { |item| item[:locale] == locale.to_s }[:title]
  end
end
