# frozen_string_literal: true

# Rails.application.config.after_initialize do
ActionText::ContentHelper.allowed_attributes.add 'id'
ActionText::ContentHelper.allowed_attributes.add 'data-bs-ride'
ActionText::ContentHelper.allowed_attributes.add 'data-bs-slide'
ActionText::ContentHelper.allowed_attributes.add 'data-bs-slide-to'
ActionText::ContentHelper.allowed_attributes.add 'data-bs-target'
# ActionText::ContentHelper.allowed_attributes.add "style"
# end
