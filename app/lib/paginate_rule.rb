class PaginateRule
  def self.call(params)
    page = ((params[:page]&.to_i || 1))
    page = 1 if page < 1
    per = params[:per]&.to_i || 10
    per = 100 if per > 100
    [page, per]
  end
end
