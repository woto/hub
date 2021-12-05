# frozen_string_literal: true

json.content render(partial: '/entities/form', locals: { entity: @entity }, formats: :html)
