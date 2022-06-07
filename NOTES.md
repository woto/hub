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
