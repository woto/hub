class Columns::BaseForm
  include ActiveModel::Serialization
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Naming

  class_attribute :all_columns
  attr_accessor :displayed_columns

  PG2ES = {
      string: { type: :text, sort: '.keyword' },
      integer: { type: :long, sort: '' },
      double: { type: :double, sort: '' },
      float: { type: :float, sort: '' },
      uuid: { type: :text, sort: '.keyword' },
      text: { type: :text, sort: nil },
      boolean: { type: :boolean, sort: '' },
      datetime: { type: :date, sort: '' },
      inet: { type: :ip, sort: '' },
      jsonb: { type: :object, sort: nil }
  }.freeze

  def attributes
    {
        'displayed_columns' => nil
    }
  end

  class << self
    def elastic_column(key)
      column = self::all_columns.find { |col| col[:key] == key }
      pg = column[:pg]
      raise "Column `#{column[:key]}` not found in Postgres table" if pg.nil?

      pg_type = column[:as] || pg.type
      PG2ES[pg_type] || raise("Unable to find mapping for `#{key}`")
    end

    def stringified_columns_for(request)
      name = self.name.demodulize.chomp('Form').underscore.pluralize
      if name == request.params[:controller]
        request.params[:cols]
      else
        strings_to_ints(self::DEFAULTS).join('.')
      end
    end

    def default_stringified_columns_for(request)
      strings_to_ints(self::DEFAULTS).join('.')
    end

    def parsed_columns_for(request)
      ints = request.params[:cols].split('.').map { |el| el.to_i}
      ints_to_strings(ints)
    end

    def ints_to_strings(ints)
      all_columns.values_at(*ints).map { |el| el[:key] }
    end

    def strings_to_ints(strings)
      arr = []
      strings.each do |col_name|
        all_columns.each_with_index do |item, idx|
          arr << idx if item[:key] == col_name
        end
      end
      arr
    end
  end
end
