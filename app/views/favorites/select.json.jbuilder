# frozen_string_literal: true

json.array! @favorites, partial: 'favorites/favorite', as: :favorite
