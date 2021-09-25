# frozen_string_literal: true

namespace :hub do
  namespace :tests do

    desc 'Seeds for testing in development'
    task seed: :environment do

        def create_post_categories_random_tree(realm)
          Array.new(20).map do
            parent = PostCategory.order('random()').find_by(realm: realm)
            PostCategory.create!(
              realm: realm,
              title: Faker::Lorem.sentence(word_count: 1, random_words_to_add: 4),
              parent: [nil, parent].sample
            )
          end
        end

        if Rails.env.development?
          admin = User.find_by(email: 'admin@example.com')

          user = User.create!(
            email: 'user@example.com',
            password: 'password',
            role: 'user'
          )

          user = FactoryBot.create(:user, role: :admin)

          I18n.available_locales.each do |locale|
            realm = Realm.pick(kind: :news, locale: locale)

            create_post_categories_random_tree(realm)
            post_categories = PostCategory.leaves.where(realm: realm).order('RANDOM()')

            20.times do
              Current.set(responsible: user) do
                post = FactoryBot.create(:post, realm: realm, user: user, post_category: post_categories.sample)
                post.update!(status: :accrued_post)
              end
            end
          end

          3.times do |i|
            user = User.create!(
              email: "user#{i + 1}@example.com",
              password: 'password',
              role: 'user'
            )

            10.times do |i|
              post = nil
              Current.set(responsible: user) do
                created_at = Faker::Date.between(from: 2.years.ago, to: Time.current)
                post = FactoryBot.create(:post, realm_kind: :post, user: user, created_at: created_at)
              end

              next unless i < 8

              Current.set(responsible: admin) do
                post.update!(status: :approved_post)
              end

              next unless i < 6

              Current.set(responsible: admin) do
                post.update!(status: :accrued_post)
              end

              next unless i < 4

              check = nil
              Current.set(responsible: user) do
                check = user.checks.create!(amount: post.amount * rand(0.9..1), currency: post.currency, status: :pending_check)
              end

              next unless i < 3

              Current.set(responsible: admin) do
                check.update!(status: :approved_check)
              end

              next unless i < 2

              Current.set(responsible: admin) do
                check.update!(status: :payed_check)
              end
            end
          end

          advertiser = Advertiser.create!(name: 'Рекламодатель 1')

          feed1 = advertiser.feeds.create!(
            attempt_uuid: SecureRandom.uuid,
            url: 'http://example.com',
            name: 'Фид 1',
            operation: 'manual',
            xml_file_path: 'spec/fixtures/files/feeds/yml-custom.xml'
          )
          Feeds::Parse.call(feed: feed1)

          feed2 = advertiser.feeds.create!(
            attempt_uuid: SecureRandom.uuid,
            url: 'http://example.com',
            name: 'Фид 2',
            operation: 'manual',
            xml_file_path: 'spec/fixtures/files/feeds/yml-simplified.xml'
          )
          Feeds::Parse.call(feed: feed2)

          advertiser = Advertiser.create!(name: 'Рекламодатель 2')

          feed3 = advertiser.feeds.create!(
            attempt_uuid: SecureRandom.uuid,
            url: 'http://example.com',
            name: 'Фид 3',
            operation: 'manual',
            xml_file_path: 'spec/fixtures/files/feeds/776-petshop+678-taganrog.xml'
          )
          Feeds::Parse.call(feed: feed3)
          Elastic::RefreshOffersIndex.call

          simple_widget = FactoryBot.create(:simple_widget, user: admin)
          attachment = ActionText::Attachment.from_attachable(simple_widget)
          Current.set(responsible: admin) do
            FactoryBot.create(:post, realm_kind: :post, user: admin, body: "<p>some text</p> #{attachment}", status: :accrued_post)
            FactoryBot.create(:post, realm_kind: :post, user: admin, body: "<p>some text</p> #{attachment}", status: :accrued_post)
          end
        end
      end

    desc 'First graph visualization'
    task graph: :environment do
      # Create a new graph
      g = GraphViz.new( :G, :type => :digraph )

      nodes = {}
      edges = []

      Transaction.group([:credit_id, :credit_label, :debit_id, :debit_label])
                 .count.each do |(credit_id, credit, debit_id, debit), count|

        credit_label = Account.find(credit_id).to_label
        key = credit_label
        unless nodes.include?(key)
          nodes[key] = g.add_nodes(key)
        end

        debit_label = Account.find(debit_id).to_label
        key = debit_label
        unless nodes.include?(key)
          nodes[key] = g.add_nodes(key)
        end

        # Create an edge between the two nodes
        key = [nodes[credit_label], nodes[debit_label]]
        unless edges.include?(key)
          g.add_edges(*key)
          edges << key
        end
      end

      # Generate output image
      g.output( :png => "hello_world.png" )
    end

    desc 'Some test for dirty'
    task dirty: :environment do

      def execute(command)
        cmd("@u = FactoryBot.create(:user, role: 'user'); " + command)
        # cmd("@u = User.user.first;                      " + command)
        cmd("@u.role = 'admin';                           " + command)
        cmd("@u.save!;                                    " + command)
        cmd("@u.save!;                                    " + command)
        cmd("@u.save!;                                    " + command)

        puts
        @u.update!(role: 'user')
      end

      def cmd(command)
        puts "#{command}: #{instance_eval(command).inspect}"
      end

      puts 'ActiveRecord'
      execute('@u.attribute_before_last_save(:role)')
      execute('@u.attribute_change_to_be_saved(:role)')
      execute('@u.attribute_in_database(:role)')
      execute('@u.attributes_in_database')
      execute('@u.changed_attribute_names_to_save')
      execute('@u.changes_to_save')
      execute('@u.has_changes_to_save?')
      execute('@u.reload')
      execute('@u.saved_change_to_attribute(:role)')
      execute('@u.saved_change_to_attribute?(:role, {})')
      execute('@u.saved_changes')
      execute('@u.saved_changes?')
      execute('@u.will_save_change_to_attribute?(:role, {})')

      puts 'ActiveModel'
      execute('@u.changed')
      execute('@u.changed?')
      execute('@u.changed_attributes')
      execute('@u.changes')
      execute('@u.changes_applied')
      execute('@u.clear_attribute_changes([:role])')
      execute('@u.clear_changes_information')
      execute('@u.previous_changes')
      execute('@u.restore_attributes([:role])')
    end
  end
end
