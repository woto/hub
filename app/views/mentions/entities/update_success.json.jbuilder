# frozen_string_literal: true

json.content render(partial: 'mentions/entities/card', locals: { entity: @entity }, formats: :html)
