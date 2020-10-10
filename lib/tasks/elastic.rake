# frozen_string_literal: true

namespace :hub do
  namespace :elastic do
    desc "Deletes all indexes"
    task delete_all: :environment do
      Elastic::DeleteAll.call
    end

    desc "Deletes all offers indexes"
    task delete_offers: :environment do
      Elastic::DeleteOffers.call
    end
  end
end
