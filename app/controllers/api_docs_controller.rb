class APIDocsController < ApplicationController
  layout 'roastme/pages'

  skip_before_action :authenticate_user!

  def index

  end
end
