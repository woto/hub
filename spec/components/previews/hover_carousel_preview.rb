class HoverCarouselPreview < ViewComponent::Preview
  layout "view_component"

  def test
    render(HoverCarouselComponent.new(images: []))
  end
end
