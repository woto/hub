module ArticlePage
  extend ActiveSupport::Concern

  included do
    MAX_PER = 100
    DEFAULT_PER = 20

    def per
      params[:per].yield_self do |p|
        break DEFAULT_PER if p.nil?

        p = p.to_i
        p < MAX_PER ? p : MAX_PER
      end
    end
  end
end
