# frozen_string_literal: true

class PrometheusJob < ApplicationJob
  queue_as :default

  def iterate_buckets(start, factor, count, &block)
    return to_enum(:iterate_buckets, start, factor, count) unless block_given?

    buckets = Prometheus::Client::Histogram.exponential_buckets(start: start, factor: factor, count: count)
    buckets.unshift(0)

    enum = buckets.each_cons(2)
    loop do
      bucket = enum.next
      yield bucket, bucket.join(' - ')
    end
  end

  def perform(*_args)
    pusher = Prometheus::Pusher.new

    docstring = 'Время успешной обработки n минут тому назад'
    metric = pusher.metric(:feeds_succeeded, :gauge,
                           docstring: docstring,
                           labels: [:minutes])
    bucket_args = [3, 4, 6]
    fields = iterate_buckets(*bucket_args).map do |(startm, endm), bname|
      <<~SQL.squish
        COUNT(
          CASE
            WHEN feeds.succeeded_at BETWEEN now() - interval '#{endm} minutes' AND now() - interval '#{startm} minutes' THEN TRUE
            ELSE NULL
          END
         ) as "#{bname}"
      SQL
    end.join(', ')
    result = Feed.select(fields)
    iterate_buckets(*bucket_args).each do |_, bname|
      metric.set(result[0][bname], labels: { minutes: bname })
    end

    indices = GlobalHelper.elastic_client.cat.indices(format: 'json', index: Elastic::IndexName.offers)

    docstring = 'Количество индексов прайсов в Elasticsearch'
    metric = pusher.metric(:feeds, :gauge,
                           docstring: docstring,
                           labels: [:service])
    metric.set(indices.size, labels: { service: 'elastic' })

    docstring = 'Количество товаров в Elasticsearch'
    metric = pusher.metric(:offers, :gauge,
                           labels: [:index],
                           docstring: docstring)
    indices.each do |index|
      metric.set(index['docs.count'].to_i, labels: { index: index['index'] })
    end

    docstring = 'Количество прайсов в Postgres'
    metric = pusher.metric(:feeds, :gauge,
                           docstring: docstring,
                           labels: [:service])
    metric.set(Feed.count, labels: { service: 'postgres' })

    docstring = 'Статусы операций прайсов'
    metric = pusher.metric(:feeds_operations, :gauge,
                           labels: [:operation],
                           docstring: docstring)
    Feed.group(:operation).count.each do |operation, count|
      metric.set(count, labels: { operation: operation })
    end

    docstring = 'Группировки ошибок прайсов'
    metric = pusher.metric(:feeds_error_classes, :gauge,
                           labels: [:error_class],
                           docstring: docstring)
    Feed.group(:error_class).count.each do |error_class, count|
      metric.set(count, labels: { error_class: error_class })
    end

    docstring = 'Количество рекламодателей в Postgres'
    metric = pusher.metric(:advertisers, :gauge,
                           docstring: docstring)
    metric.set(Advertiser.count)

    docstring = 'Количество категорий в Postgres'
    metric = pusher.metric(:feed_categories, :gauge,
                           docstring: docstring)
    metric.set(FeedCategory.count)

    docstring = 'Категории по уровню вложенности'
    metric = pusher.metric(:feed_categories_depths, :gauge,
                           labels: [:depth],
                           docstring: docstring)
    FeedCategory.group(:ancestry_depth).count.each do |depth, count|
      metric.set(count, labels: { depth: depth })
    end

    # TODO: move metric to import process
    # # TODO: Add flag for skip monitoring (eg. bad_categories)
    # docstring = 'Категории по уровню вложенности'
    # metric = pusher.metric(:feed_categories_parent_not_found, :gauge,
    #                        labels: [:feed_id],
    #                        docstring: docstring)
    # FeedCategory.where(parent_not_found: nil).group(:feed_id).order('count_all DESC')
    #             .limit(10).count.each do |feed_id, count|
    #   metric.set(count, labels: { feed_id: feed_id })
    # end

    # pusher.push
  end
end
