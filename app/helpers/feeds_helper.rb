# frozen_string_literal: true

module FeedsHelper
  def _downloaded_file_size(value)
    value&.to_s(:human_size)
  end

  def _xml_file_path(value)
    value
  end

  def _url(value)
    value
  end

  def _language(value)
    render FlagComponent.new(language: value)
  end
end
