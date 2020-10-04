# frozen_string_literal: true

class PaginationRules
  MAX_PER = 100
  DEFAULT_PER = 20
  PER_VARIANTS = [5, 10, DEFAULT_PER, 50, MAX_PER].freeze
  attr_accessor :per, :page, :default_per, :max_per, :per_variants

  def initialize(request, default_per = DEFAULT_PER, max_per = MAX_PER, per_variants = PER_VARIANTS)
    @default_per = default_per
    @max_per = max_per
    @per_variants = per_variants

    # Range: (1..)
    @page = ((request.params[:page]&.to_i || 1))
    @page = 1 if @page < 1

    # Range: (per|default_per|DEFAULT_PER..max_per)
    @per = request.params[:per]&.to_i || default_per
    @per = max_per if @per > max_per
    @per = @default_per unless @per_variants.include?(@per)
  end
end
