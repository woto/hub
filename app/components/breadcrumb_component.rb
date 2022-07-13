# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  renders_one :root_item, lambda { |title:, url:|
    Breadcrumb::RootItemComponent.new(title: title, url: url)
  }
  renders_many :items, lambda { |title:, url:|
    Breadcrumb::ItemComponent.new(title: title, url: url)
  }
end
