class Left::Menu::CategoryLinkComponent < ViewComponent::Base
  def initialize(category:, doc_count:, request:)
    if category
      @category = category
      @doc_count = doc_count
      @path = request.params.slice(*GlobalHelper.workspace_params).tap do |h|
        h[:category_id] = category.id
        h[:only] = '1' if category.try(:only)
      end
      @dom_id = dom_id(category, 'left')
      @dom_class = dom_class(category, 'left')
    end
  end

  def render?
    @category
  end
end
