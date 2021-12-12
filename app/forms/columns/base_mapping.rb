class Columns::BaseMapping
  include ActiveModel::Serialization
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Naming

  class_attribute :all_columns
  attr_accessor :displayed_columns
  attr_accessor :model
  attr_accessor :state

  validates :displayed_columns, length: { minimum: 2 }

  PG2ES = {
    string: { type: :text, sort: '.keyword' },
    integer: { type: :long, sort: '' },
    double: { type: :double, sort: '' },
    decimal: { type: :double, sort: '' },
    float: { type: :float, sort: '' },
    uuid: { type: :text, sort: '.keyword' },
    text: { type: :text, sort: nil },
    boolean: { type: :boolean, sort: '' },
    datetime: { type: :date, sort: '' },
    inet: { type: :ip, sort: '' },
    jsonb: { type: :object, sort: nil }
  }.freeze

  class << self
    def elastic_column(key)
      column = self::all_columns.find { |col| col[:key] == key }
      pg = column[:pg]
      raise "`pg` key has invalid value in #{self}.all_columns for key `#{column[:key]}`" if pg.nil?

      pg_type = column[:as] || pg.type
      PG2ES[pg_type] || raise("Unable to find mapping for `#{key}` with column type `#{pg_type}`")
    end

    def parsed_columns_for(controller, request, role)
      role = 'guest' if role.nil?

      (request[:columns] || controller.workspace.columns || []).select do |column_name|
        all_columns.find do |settings_column|
          settings_column[:key] == column_name &&
            settings_column[:roles].include?(role)
        end
      end
    end
  end
end
