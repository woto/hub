class CheckDecorator < ApplicationDecorator
  def status
    h.badge(status: super)
  end

  def amount
    h.link_to h.check_path(_id) do
      h.tag.mark do
        decorate_money(super, currency)
      end
    end
  end

  # def payed_at
  #   h.render TimeAgoComponent.new(datetime: super)
  # end
end
