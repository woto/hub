# frozen_string_literal: true

require 'rails_helper'

describe GlobalHelper do
  describe '.currencies_table' do
    it 'returns currencies hash' do
      expect(described_class.currencies_table).to include({ rub: 643 })
    end
  end
end
