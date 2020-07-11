# # frozen_string_literal: true
# require 'faraday_curl'
# require 'logger'
#
# # FaradayTest
# class FaradayTest
#   def self.call
#     domain = 'http://example.com/'
#     logger = Logger.new(STDOUT)
#
#     resp = Faraday.new(url: domain) do |f|
#       f.request :url_encoded
#       f.request :curl, logger, :warn
#       f.adapter Faraday.default_adapter
#     end
#     puts resp.get
#   end
# end
