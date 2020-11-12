class Decorators::Post::StatusComponent < ViewComponent::Base
  def initialize(status:)
    @status = status
    @color = case status
             when 'draft', 'pending'
               'gray'
             when 'accrued'
               'green'
             when 'rejected', 'canceled'
               'red'
             end
  end
end
