class APIDocsController < ApplicationController
  layout 'backoffice'
  skip_before_action :authenticate_user!

  def index

  end
end
