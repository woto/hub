# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    elastic_client.indices.delete index: ::Elastic::IndexName.wildcard

    User.setup_index(Columns::UserForm)
    User.__elasticsearch__.create_index!
    User.__elasticsearch__.refresh_index!

    Feed.setup_index(Columns::FeedForm)
    Feed.__elasticsearch__.create_index!
    Feed.__elasticsearch__.refresh_index!

    Post.setup_index(Columns::PostForm)
    Post.__elasticsearch__.create_index!
    Post.__elasticsearch__.refresh_index!
  end
end
