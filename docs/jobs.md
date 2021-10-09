# Jobs

#### PostCategories::YandexMarketJob

```ruby
PostCategories::YandexMarketJob.perform_later
```
Downloads http://download.cdn.yandex.net/market/market_categories.xls and creates
post categories with same structure.

#### Sync::AdmitadJob

```ruby
Sync::AdmitadJob.perform_later
```

Creates advertisers and feeds from `admitad.ru`.

#### Import::ProcessJob

```ruby
Feed.find_each { |feed| Import::ProcessJob.perform_later(feed) }
```
or
```ruby
Feed.count.times { Import::ProcessJob.perform_later }
```

Synchronize all feeds