require 'rails_helper'

describe 'Caching', focus: true do
  let(:key) { 'persistent' }
  let(:value) { Faker::Lorem.word }

  2.times do |i|
    it "checks that cache is working and not stored across tests. attempt #{i}" do
      expect(Rails.cache.read(key)).to be_nil
      Rails.cache.write(key, value)
      expect(Rails.cache.read(key)).to eq(value)
    end
  end
end
