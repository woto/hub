class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end

  def self.collection_decorator_class
    PaginatingConcern
  end

  def updated_at
    h.render TimeAgoComponent.new(datetime: object['_source']['updated_at'])
  end

  def created_at
    h.render TimeAgoComponent.new(datetime: object['_source']['created_at'])
  end

  delegate_all

  private

  def decorate_datetime(datetime)
    h.render TimeAgoComponent.new(datetime: datetime)
  end

  def decorate_text(text)
    GlobalHelper.decorate_text(text)
  end

  def decorate_money(amount, currency)
    raise "currency can't be nil" if currency.nil?

    GlobalHelper.decorate_money(amount, currency)
  end

  def method_missing(m, *args, &block)
    method_name = m.to_s
    if method_name.first == '_'
      object[method_name]
    else
      if object['_source'].key?(method_name)
        object['_source'][method_name]
      else
        Rails.logger.info("#{method_name} in decorator was not found")
        ""
      end
    end
  end
end
