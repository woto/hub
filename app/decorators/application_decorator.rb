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

  delegate_all

  def updated_at
    decorate_datetime(__method__)
  end

  def created_at
    decorate_datetime(__method__)
  end

  private

  def decorate_datetime(attribute_name)
    return if object.public_send(attribute_name).blank?

    h.tag.span Time.zone.parse(object.public_send(attribute_name)).iso8601,
               style: 'cursor: pointer',
               data: {
                   controller: 'timeago',
                   timeago_source_time: Time.zone.parse(object.public_send(attribute_name)).iso8601,
                   action: 'click->timeago#showSourceTime'
               }
  end
end
