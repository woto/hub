# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::Hashify do
  subject { described_class.call(doc) }

  let(:doc) { Nokogiri::XML(xml).children.first }

  describe 'simple xml' do
    let(:xml) do
      %(
        <offer attribute1="123" attribute2="abc">
          <categoryId>category 1</categoryId>
          <picture>http://example.com/image1.png</picture>
          <picture>http://example.com/image2.png</picture>
          <description><![CDATA[<p>Description</p>]]></description>
          <param name="color">white</param>
          <param name="sex">male</param>
          <delivery-options>Skipped because includes in skipped keys settings</delivery-options>
        </offer>
        )
    end

    it 'works' do
      expect(subject).to eq(
        {
          Import::Offers::Hashify::SELF_NAME_KEY => {
            'attribute1' => '123',
            'attribute2' => 'abc'
          },
          'categoryId' => [{ Import::Offers::Hashify::HASH_BANG_KEY => 'category 1' }],
          'description' => [{ '#' => 'Description' }],
          'param' => [
            {
              Import::Offers::Hashify::HASH_BANG_KEY => 'white',
              '@name' => 'color'
            },
            { Import::Offers::Hashify::HASH_BANG_KEY => 'male',
              '@name' => 'sex' }
          ],
          'picture' => [
            { '#' => 'http://example.com/image1.png' },
            { '#' => 'http://example.com/image2.png' }
          ]
        }
      )
    end
  end

  describe 'nested tags' do
    let(:xml) do
      %(
        <offer>
          <pickup-options>
             <option/>
          </pickup-options>
        </offer>
      )
    end

    it 'does not able to process tags like this for now' do
      expect { subject }.to raise_error(Import::Process::ElasticUnexpectedNestingError)
    end
  end

  describe 'multiple attributes' do
    let(:xml) do
      %(
        <offer>
          <tag a="1a" b="1b" c="1c"/>
        </offer>
      )
    end

    it 'does not able to process tags like this for now' do
      expect(subject).to eq({ '*' => {}, 'tag' => [{ '#' => '', '@a' => '1a', '@b' => '1b', '@c' => '1c' }] })
    end
  end
end
