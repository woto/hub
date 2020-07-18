# frozen_string_literal: true

class Ext::Admitad::Api::Campaigns::ParseFeed::Offers
  include ApplicationInteractor

  SELF_NAME = '*'

  def initialize(context)
    @offers = []
    super
  end

  def append(doc)
    @current = Hash.new { |hash, key| hash[key] = [] }
    @current[SELF_NAME] = doc.to_h

    doc.elements.each do |child|
      @current[child.name] << hashify(child)
    end

    @offers << @current
  end

  def flush
    return if @offers.empty?

    client = Elasticsearch::Client.new Rails.application.config.elastic
    client.bulk(index: Elastic::IndexName.offers(context.feed.slug),
                body: @offers.map { |offer| { index: { _id: offer[SELF_NAME]['id'], data: offer } } })

    @offers = []
  end

  def size
    @offers.size
  end

  private

  def hashify(child)

    # if child.attributes.size > 0 && child.name != 'param'
    #   binding.pry
    #   1
    # end

    unless child.elements.empty?
      binding.pry
      p 1
    end

    if child.children.size > 1
      binding.pry
      p 1
    end

    child.to_h
         .transform_keys { |k| "@#{k}" }
         .merge('#' => child.text)
  end
end
