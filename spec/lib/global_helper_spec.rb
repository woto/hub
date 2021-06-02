# frozen_string_literal: true

require 'rails_helper'

describe GlobalHelper do
  describe '.currencies_table' do
    it 'returns currencies hash' do
      expect(described_class.currencies_table).to include({ rub: 643 })
    end
  end

  describe ".decorate_money" do
    it 'decorates number in money format' do
      expect(described_class.decorate_money(1, :rub)).to eq('₽1,00')
    end
  end
end
