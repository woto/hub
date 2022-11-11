class BookmarkPreview < ViewComponent::Preview
  layout "view_component"

  def test
    render(BookmarkComponent.new(ext_id: '', favorites_items_kind: ''))
  end
end
