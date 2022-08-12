# frozen_string_literal: true

module ApplicationHelper

  def serialize_user_attributes(user)
    to_return = {}
    if user
      to_return[:user_id] = user.id
      to_return[:email] = user.email

      to_return[:links] = [
        {
          title: t('header.menu.settings'),
          url: settings_profile_path,
          method: '',
          icon: ''
        },
        {
          title: t('header.menu.logout'),
          url: destroy_user_session_path,
          method: 'delete',
          icon: ''
        }
      ]

      if user.profile
        to_return[:name] = user.profile.name
      end
    else
      to_return[:links] = [{
                  title: t('header.menu.login'),
                  url: new_user_session_path,
                  method: 'get',
                  icon: 'login'
                }]
    end

    to_return[:avatar] = if user && user.avatar.present?
                url_for(user.avatar.variant(resize_to_limit: [200, 200]))
              else
                asset_pack_path('media/images/avatar-placeholder.png')
                         end
    to_return
  end

  def serialize_language_attributes
    {
      title: t('header.menu.language'),
      languages:
        I18n.available_locales.map do |locale|
          {
            title: system_locale_to_human(locale),
            url: path_for_switch_language(locale, Current.realm&.kind) ||
              url_for(
                Tools::SwitchLanguage.call(
                  subdomains: request.subdomains,
                  host: request.host,
                  locale: locale
                ).object
              )
          }
        end
    }
  end

  def articles_by_month_link(month)
    articles_by_month_path(
      month: month,
      per: params[:per],
      sort: params[:sort],
      order: params[:order]
    )
  end

  def articles_by_tag_link(tag)
    articles_by_tag_path(
      tag: tag,
      per: params[:per],
      sort: params[:sort],
      order: params[:order]
    )
  end

  def articles_by_category_link(category_id)
    articles_by_category_path(
      category_id: category_id,
      per: params[:per],
      sort: params[:sort],
      order: params[:order]
    )
  end

  def articles_link
    articles_path(
      per: params[:per],
      sort: params[:sort],
      order: params[:order]
    )
  end

  def article_link(id)
    article_path(
      id: id,
      per: params[:per],
      sort: params[:sort],
      order: params[:order]
    )
  end

  def resolve_widgetable_partial(widget, purpose: 'articles')
    case widget.widgetable.class.name.underscore
    when 'widgets/simple'
      "widgets/simples/#{purpose}/widget"
    else
      raise 'Unexpected widgetable class'
    end
  end

  # TODO: Add test later for views/layouts backoffice, centered, homepage
  def data_attributes_for_body
    {
      'data-is-authenticated': user_signed_in?,
      'data-role': current_user&.role || 'guest',
      'data-current-time': Time.current,
      'data-controller': 'global',
      'data-action': 'showToast@window->global#showToast'
    }
  end

  def collection_for_columns
    keys = @settings[:form_class].parsed_columns_for(controller, request, current_user&.role) |
           @settings[:form_class]
           .all_columns
           .reject { _1[:roles].exclude?(current_user&.role || 'guest') }
           .map { _1[:key] }

    keys.compact_blank.map do |k|
      [t(k, scope: [:table, :long, @settings[:singular]]), k]
    end
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

  def feeds_languages_for_filter
    return @feeds_languages_for_filter if defined?(@feeds_languages_for_filter)

    hsh = Hash.new(0)

    Feed.where.not(languages: {})
        .pluck(:languages)
        .each do |languages|
      languages.each { |k, v| hsh[k] += v }
    end

    arr = hsh.sort { |a, b| -a.second <=> -b.second }

    @feeds_languages_for_filter = arr.map do |obj1|
      title = Rails.application.config.global[:locales].find do |obj2|
        break obj2[:title] if obj1.first == obj2[:locale]
      end

      LocaleStruct.new(
        locale: obj1.first,
        count: obj1.second,
        title: title || obj1.first
      )
    end
  end

  # TODO: find a better place
  def trix_translations
    locales = {}
    Rails.configuration.i18n.available_locales.each do |locale|
      locales[locale.downcase] = {
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

  def landing1_widgets
    sql = <<~SQL
      SELECT widgets.*
      FROM (SELECT *, unnest(posts) post_id FROM widgets) widgets
               JOIN posts ON posts.id = post_id AND posts.status = '4'
      ORDER BY id DESC
      LIMIT 4;
    SQL
    Widget.find_by_sql(sql)
  end

  # TODO: add proposal on adding this feature. The problem is that the blobs may be not attached to records.
  # https://stackoverflow.com/questions/61893089/get-metadata-of-active-storage-variant
  # https://stackoverflow.com/questions/3332237/image-resizing-algorithm
  def new_size_for_lightbox(max_width, max_height, metadata_width, metadata_height)
    max_width = max_width.to_f
    max_height = max_height.to_f
    metadata_width = metadata_width.to_f
    metadata_height = metadata_height.to_f

    # TODO: add sending error to sentry or grafana
    return [nil, nil] if metadata_width.zero? || metadata_height.zero?

    w_ratio = metadata_width / max_width
    h_ratio = metadata_height / max_height

    max_ratio = [w_ratio, h_ratio].max

    new_width = metadata_width / max_ratio
    new_height = metadata_height / max_ratio

    [new_width, new_height]
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
