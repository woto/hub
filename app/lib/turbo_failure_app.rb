# frozen_string_literal: true

# # NOTE: taken from https://gorails.com/episodes/devise-hotwire-turbo?autoplay=1
class TurboFailureApp < Devise::FailureApp
  def skip_format?
    %w(html turbo_stream */*).include? request_format.to_s
  end
end

