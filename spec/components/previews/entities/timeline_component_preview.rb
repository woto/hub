
class Entities::TimelineComponentPreview < ViewComponent::Preview
  layout "view_component"

  def test
    entity = Cite.last.entity
    # blocks = Entities::Timeline.call(entity_id: entity.id.to_s).object
    blocks = Entities::TimelineInteractor.call(entity_id: entity.id, count: 10).object
    render ReactComponent.new(name: 'EntitiesTimeline',
                              class: '',
                              props: { entityId: 6783, opened: true })
  end
end
