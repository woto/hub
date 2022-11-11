
```ruby
        image = data.delete('image')
        info.assign_attributes(
          data: data,
          images: [Image.new(image_data_uri: image)],
          lookup: lookup,
          scraped_at: Time.current
        )
        info.save!
```

```ruby
        def get_canonical_url(data)
          doc = Nokogiri::HTML.fragment(data['html'])
          doc.at('link[rel="canonical"]')&.attr('href')
        end
```


```ruby
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
```

```ruby
        # grape
        # status result[:status]
        # body result[:body]
```

```ruby
# include Hostnameable
# hostnameable attribute_name: :title

...

module Hostnameable
  extend ActiveSupport::Concern

  included do
    belongs_to :hostname, counter_cache: true, optional: true
    before_validation :fill_hostname

    private

    def fill_hostname
      value = send(self.class.attribute_name)
      return if value.blank?

      title = begin
        URI.parse(value).hostname
      rescue StandardError
        nil
      end

      self.hostname = Hostname.find_or_create_by(title: title)
    end
  end

  class_methods do
    attr_accessor :attribute_name

    def hostnameable(attribute_name:)
      @attribute_name = attribute_name
    end
  end
end
```

```ruby
class Hostname < ApplicationRecord
  has_many :mentions, dependent: :restrict_with_error
  has_many :entities, dependent: :restrict_with_error
  has_many :lookups

  def attempts(label: nil, period: nil)
    result = attempts_count(label: label, period: period)

    success = result[true].to_f
    failure = result[false].to_f

    # unless ['github.com', 'www.youtube.com', 't.me'].include?(title)
    #   raise 'hostname requests lock' if lookups_count > 1000
    # end

    # raise 'overall requests lock' if failure + success > 300
    # raise 'failure requests lock' if failure > 100
    # raise 'rate requests lock' if failure / success > 0.5
  end

  def attempts_count(label: nil, period: nil)
    rel = lookups.joins(infos: :attempts).group("attempts.is_success")
    rel = rel.where(infos: { label: label } ) if label
    rel = rel.where(infos: { attempts: { created_at: period } }) if period
    rel.count
  end

  def to_label
    title
  end
end
```

```ruby
  describe '#fill_hostname' do
    it_behaves_like 'shared_hostname_new' do
      subject { build(:entity) }
    end

    it_behaves_like 'shared_hostname_existed' do
      subject { build(:entity, title: "https://#{hostname.title}/foo") }

      let!(:hostname) { create(:hostname) }
    end
  end
```

```ruby
shared_examples 'shared_hostname_existed' do
  context 'when hostname already exists' do
    it 'assigns it to the subject without hostname creation' do
      expect do
        expect do
          subject.save
        end.not_to change(Hostname, :count)
      end.to change(described_class, :count)

      expect(subject.hostname).to eq(hostname)
    end
  end
end
```

```ruby
shared_examples 'shared_hostname_new' do
  context 'when hostname of passed url not exists yet' do
    it 'creates hostname and assigns it to the subject' do
      expect do
        expect do
          subject.save
        end.to change(Hostname, :count)
      end.to change(described_class, :count)

      expect(subject.hostname).to eq(Hostname.last)
    end
  end
end
```

```ruby
h[:images] = [Image.new(image_remote_url: image)] if image
```
