# frozen_string_literal: true

RSpec.shared_context 'with shared authentication' do
  let(:user) do
    create(:user)
  end

  let(:token) do
    create(:oauth_access_tokens, resource_owner_id: user.id)
  end

  # Homeland of xget xpost xpatch xput xhead xdelete
  %w[get post patch put head delete].each do |method|
    define_method("x#{method}") do |*args|
      path, args = args
      args ||= {}
      args = args.with_indifferent_access
      args.deep_merge!(headers: { 'Authorization' => "Bearer #{token.token}" })

      process(method, path, **args.symbolize_keys)
    end
  end

end
