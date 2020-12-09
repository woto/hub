class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end
  include FavorableConcern

  def self.collection_decorator_class
    PaginatingConcern
  end

  def updated_at
    decorate_datetime(object['_source']['updated_at'])
  end

  def created_at
    decorate_datetime(object['_source']['created_at'])
  end

  delegate_all

  private

  def decorate_datetime(datetime)
    GlobalHelper.decorate_datetime(datetime, h)
  end

  def decorate_money(amount, currency)
    raise "currency can't be nil" if currency.nil?
    GlobalHelper.decorate_money(amount, currency, h)
  end

  def method_missing(m, *args, &block)
    method_name = m.to_s
    if method_name.first == '_'
      object[method_name]
    else
      object['_source'][method_name]
    end
  end
end
