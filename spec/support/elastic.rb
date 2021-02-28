# frozen_string_literal: true

# require_relative '001_helpers.rb'
#
# include Helpers

# RSpec.configure do |config|
#   config.before(:each) do
#     elastic_client.indices.delete index: ::Elastic::IndexName.wildcard
#     GlobalHelper.create_elastic_indexes
#   end
# end

shared_examples 'elasticable' do
  let(:model) { described_class.name.underscore }

  it 'index newly created documents' do
    Current.set(responsible: create(:user)) do
      record = build(model)
      expect(record).to receive(:send_document_to_elasticsearch)
      record.save!
    end
  end

  it 'index changed documents' do
    Current.set(responsible: create(:user)) do
      record = create(model)
      expect(record).to receive(:send_document_to_elasticsearch)
      record.touch
    end
  end

  context 'when model attributes does not changed' do
    it 'does not index document' do
      Current.set(responsible: create(:user)) do
        record = create(model)
        expect(record).not_to receive(:send_document_to_elasticsearch)
        record.save!
      end
    end
  end

  context 'when attribute marked as dirty' do
    it 'index document' do
      Current.set(responsible: create(:user)) do
        record = create(model)
        record.id_will_change!
        expect(record).to receive(:send_document_to_elasticsearch)
        record.save!
      end
    end
  end
end

def elastic_client
  @elastic_client ||= Elasticsearch::Client.new Rails.application.config.elastic
end

RSpec.configure do |config|
  config.before do
    elastic_client.indices.delete index: ::Elastic::IndexName.wildcard
    GlobalHelper.create_elastic_indexes
  end

  # config.before(:each) do
  #   elastic_client.delete_by_query(
  #     index: 'test.*',
  #     wait_for_completion: true,
  #     body: {
  #       query: {
  #         match_all: {}
  #       }
  #     }
  #   )
  # end
end

# frozen_string_literal: true

# RSpec.configure do |config|
#   config.before(:each) do
#     elastic_client.indices.delete index: ::Elastic::IndexName.wildcard
#     GlobalHelper.create_elastic_indexes
#   end
# end

# frozen_string_literal: true

# id = Time.current.to_i
#
# RSpec.configure do |config|
#   config.before(:suite) do
#     client = Elasticsearch::Client.new Rails.application.config.elastic
#     GlobalHelper.create_elastic_indexes
#     client.snapshot.create_repository(
#         repository: 'my_backup',
#         body: {
#             "type": 'fs',
#             "settings": {
#                 "location": 'my_backup_location'
#             }
#         }
#     )
#     client.snapshot.create(
#         repository: 'my_backup',
#         snapshot: "snapshot_#{id}",
#         wait_for_completion: true,
#         body: {
#             indices: 'test*'
#         }
#     )
#   end
#
#   config.before do
#     elastic_client.indices.delete index: ::Elastic::IndexName.wildcard
#     client = Elasticsearch::Client.new Rails.application.config.elastic
#     client.snapshot.restore(
#         repository: 'my_backup',
#         snapshot: "snapshot_#{id}",
#         body: {
#             indices: 'test*'
#         },
#         wait_for_completion: true
#     )
#     # GlobalHelper.create_elastic_indexes
#   end
# end
