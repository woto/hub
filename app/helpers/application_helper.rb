# frozen_string_literal: true

module ApplicationHelper

  # TODO: Add test later for views/layouts backoffice, centered, homepage
  def data_attributes_for_body
    {
      'data-is-authenticated': user_signed_in?,
      'data-role': current_user&.role || 'guest',
      'data-current-time': Time.current
    }
  end

  def data_attributes_for_navbar_favorite
    {
      'data-controller': 'navbar-favorite',
      'data-navbar-favorite-dropdown-list-path-value': navbar_favorite_list_favorites_path,
      'data-navbar-favorite-others-path-value': favorites_path,
      'data-navbar-favorite-no-favorites-value': t('.no_favorites')
    }
  end

  def test_id
    'data-test-id'
  end

  def test_class
    'data-test-class'
  end

  def system_locale_to_human(locale)
    Rails.application.config.global[:locales].find { |item| item[:locale] == locale.to_s }[:title]
  end

  # TODO: find a better place
  def trix_translations
    locales = {}
    Rails.configuration.i18n.available_locales.each do |locale|
      locales[locale] = {
        attachFiles: I18n.t(:attachFiles, scope: 'trix', locale: locale),
        bold: I18n.t(:bold, scope: 'trix', locale: locale),
        bullets: I18n.t(:bullets, scope: 'trix', locale: locale),
        byte: I18n.t(:byte, scope: 'trix', locale: locale),
        bytes: I18n.t(:bytes, scope: 'trix', locale: locale),
        captionPlaceholder: I18n.t(:captionPlaceholder, scope: 'trix', locale: locale),
        code: I18n.t(:code, scope: 'trix', locale: locale),
        heading1: I18n.t(:heading1, scope: 'trix', locale: locale),
        indent: I18n.t(:indent, scope: 'trix', locale: locale),
        italic: I18n.t(:italic, scope: 'trix', locale: locale),
        link: I18n.t(:link, scope: 'trix', locale: locale),
        numbers: I18n.t(:numbers, scope: 'trix', locale: locale),
        outdent: I18n.t(:outdent, scope: 'trix', locale: locale),
        quote: I18n.t(:quote, scope: 'trix', locale: locale),
        redo: I18n.t(:redo, scope: 'trix', locale: locale),
        remove: I18n.t(:remove, scope: 'trix', locale: locale),
        strike: I18n.t(:strike, scope: 'trix', locale: locale),
        undo: I18n.t(:undo, scope: 'trix', locale: locale),
        unlink: I18n.t(:unlink, scope: 'trix', locale: locale),
        url: I18n.t(:url, scope: 'trix', locale: locale),
        urlPlaceholder: I18n.t(:urlPlaceholder, scope: 'trix', locale: locale),
        GB: I18n.t(:GB, scope: 'trix', locale: locale),
        KB: I18n.t(:KB, scope: 'trix', locale: locale),
        MB: I18n.t(:MB, scope: 'trix', locale: locale),
        PB: I18n.t(:PB, scope: 'trix', locale: locale),
        TB: I18n.t(:TB, scope: 'trix', locale: locale),
        embedWidget: I18n.t(:embedWidget, scope: 'trix', locale: locale)
      }
    end
    locales
  end

  def conditional_tag(name, condition, options = nil, &block)
    if condition
      content_tag name, capture(&block), options
    else
      capture(&block)
    end
  end

  def badge(status:)
    color = case status
             when 'draft_post'
               'grey'
             when 'pending_post', 'pending_check'
               'cyan'
             when 'approved_post', 'approved_check'
               'teal'
             when 'accrued_post', 'payed_check'
               'green'
             when 'rejected_post'
               'orange'
             when 'canceled_post'
               'red'
             end
    tag.span class: "badge bg-#{color}" do
      t(status, scope: 'posts.show.badge.statuses')
    end
end

  # def tree_item(parent, children)
  #   concat render('feed_category_checkbox', name: parent.name, style: "margin-left: #{parent.depth * 20}px")
  #   children.each { |k, v| tree_item(k, v) } && nil
  # end

  # def method_missing(_name, *args)
  #   scalar = args.first
  #   if scalar.is_a?(String)
  #     truncate(scalar)
  #   elsif scalar.is_a?(Hash)
  #     truncate(scalar.to_s)
  #   elsif scalar.is_a?(Array)
  #     truncate(scalar.to_s)
  #   elsif scalar.is_a?(ActiveSupport::TimeWithZone)
  #     l(scalar, format: :short)
  #   else
  #     scalar
  #   end
  # end
end
