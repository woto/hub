class ReviewsConstraint
  def matches?(request)
    request.host == 'reviews.lvh.me'
  end
end
