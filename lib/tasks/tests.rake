# frozen_string_literal: true

namespace :hub do
  namespace :tests do

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
