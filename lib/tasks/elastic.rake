# frozen_string_literal: true

namespace :hub do
  namespace :elastic do
    desc "Deletes all indexes"
    task clean: :environment do
      Elastic::DeleteIndexInteractor.call(index: Elastic::IndexName.pick('*'))
    end
  end
end
