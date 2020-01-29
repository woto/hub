module ArticlePage
  extend ActiveSupport::Concern

  MAX_PER = 100
  DEFAULT_PER = 20

  included do
    def per
      params[:per].yield_self do |p|
        break DEFAULT_PER if p.nil?

        p = p.to_i
        p < MAX_PER ? p : MAX_PER
      end
    end
  end
end
