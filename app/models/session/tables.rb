module Session
  class Tables
    # NAMESPACE = self.name
    # MODEL_NAMES = ['tests', 'articles', 'feeds', 'advertisers', 'posts', 'offers', 'users']
    #
    # def self.call(*args)
    #   new(*args)
    # end
    #
    # def initialize(request, model = nil)
    #   @request = request
    #   @model = model || request.params[:controller]
    #   raise "Wrong model name #{@model.inspect}" unless MODEL_NAMES.include?(@model)
    # end
    #
    # def per
    #   self[:per]
    # end
    #
    # # def per=(val)
    # #   self[:per] = val
    # # end
    #
    # def columns
    #   self[:columns]
    # end
    #
    # # def columns=(val)
    # #   self[:columns] = val
    # # end
    #
    # # per GlobalHelper.table(request).dig(:columns, :advertiser)
    #
    # private
    #
    # def [](key)
    #   @request.params[:per]
    #   # @request.session.dig(NAMESPACE, @model, key)
    # end
    #
    # def []=(key, value)
    #   @request.session[NAMESPACE] ||= {}
    #   @request.session[NAMESPACE][@model] ||= {}
    #   @request.session[NAMESPACE][@model][key] = value
    # end
  end
end
