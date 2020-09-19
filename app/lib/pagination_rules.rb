# frozen_string_literal: true

class PaginationRules
  MAX_PER = 100
  DEFAULT_PER = 20
  PER_VARIANTS = [5, 10, DEFAULT_PER, 50, MAX_PER].freeze

  def self.call(request, default_per = DEFAULT_PER, max_per = MAX_PER, per_variants = PER_VARIANTS)
    # Range: (1..)
    page = ((request.params[:page]&.to_i || 1))
    page = 1 if page < 1

    # Range: (per|default_per|DEFAULT_PER..max_per)
    per = request.params[:per]&.to_i || Session::Tables::(request).per || default_per
    per = max_per if per > max_per
    per = DEFAULT_PER unless PER_VARIANTS.include?(per)
    Session::Tables::(request).per = per

    [page, per]
  end
end
