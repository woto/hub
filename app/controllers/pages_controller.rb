class PagesController < ApplicationController
  layout 'roastme/pages'
  skip_before_action :authenticate_user!

  def show
    pages_dir = Rails.root.join('data/pages/')
    relative_file_path = pages_dir.join("#{params[:page]}.md")
    absolute_file_path = File.expand_path(relative_file_path)
    raise unless absolute_file_path.to_s.starts_with?(pages_dir.to_s)

    # TODO: ask somebody about security
    begin
      markdown = File.read(absolute_file_path)
      @html = Commonmarker.to_html(markdown)
    rescue Errno::ENOENT
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
