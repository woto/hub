# # frozen_string_literal: true

# require 'rails_helper'

# describe 'CORS', type: :request do
#   CORS_KEYS = %w[Access-Control-Allow-Origin Access-Control-Allow-Methods
#                  Access-Control-Expose-Headers Access-Control-Max-Age].freeze

#   it 'returns CORS headers' do
#     get '/api/v1/posts', headers: { 'HTTP_ORIGIN' => '*' }
#     CORS_KEYS.each do |key|
#       expect(response.headers).to have_key(key)
#     end
#   end

#   it 'does not return any CORS headers' do
#     get '/posts', headers: { 'HTTP_ORIGIN' => '*' }
#     CORS_KEYS.each do |key|
#       expect(response.headers).not_to have_key(key)
#     end
#   end
# end
