# frozen_string_literal: true

module FeedsHelper

  def _downloaded_file_size(value)
    raise 'FeedsHelper#_downloaded_file_size'
    value&.to_s(:human_size)
  end

  def _xml_file_path(value)
    raise 'FeedsHelper#_xml_file_path'
    value
  end

  def _url(value)
    raise 'FeedsHelper#_url'
    value
  end

  def _language(value)
    raise 'FeedsHelper#_language'
    render FlagComponent.new(language: value)
  end
end
