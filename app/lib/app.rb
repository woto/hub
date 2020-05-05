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


- language: 'English'
english_name: 'English'
disabled: false
domain: "//en.#{ENV['DOMAIN_NAME']}"
- language: '中文'
english_name: 'Chinese'
disabled: false
domain: "//zh.#{ENV['DOMAIN_NAME']}"
- language: '日本語'
english_name: 'Japanese'
disabled: true
domain: "//ja.#{ENV['DOMAIN_NAME']}"
- language: 'Español'
english_name: 'Spanish'
disabled: true
domain: "//es.#{ENV['DOMAIN_NAME']}"
- language: 'Deutsch'
english_name: 'German'
disabled: true
domain: "//de.#{ENV['DOMAIN_NAME']}"
- language: 'Français'
english_name: 'French'
disabled: true
domain: "//fr.#{ENV['DOMAIN_NAME']}"
- language: '한국어'
english_name: 'Korean'
disabled: true
domain: "//ko.#{ENV['DOMAIN_NAME']}"
- language: 'Português'
english_name: 'Portuguese'
disabled: true
domain: "//pt.#{ENV['DOMAIN_NAME']}"
- language: 'Italiano'
english_name: 'Italian'
disabled: true
domain: "//it.#{ENV['DOMAIN_NAME']}"
- language: 'Русский'
english_name: 'Russian'
disabled: false
domain: "//ru.#{ENV['DOMAIN_NAME']}"
