class App
  extend Dry::Configurable

  # Pass a block for nested configuration (works to any depth)
  setting :database do
    # Can pass a default value
    setting :dsn, 'sqlite:memory'
  end
  # Defaults to nil if no default value is given
  setting :adapter
  # Pre-process values
  setting(:path, 'test') { |value| Pathname(value) }
  # Passing the reader option as true will create attr_reader method for the class
  setting :pool, 5, reader: true
  # Passing the reader attributes works with nested configuration
  setting :uploader, reader: true do
    setting :bucket, 'dev'
  end
end
