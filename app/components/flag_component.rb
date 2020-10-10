# frozen_string_literal: true

class FlagComponent < ViewComponent::Base
  def initialize(language:)
    @language = language
    @code = case language.to_s.downcase
            when 'russian'
              'ru'
            when 'english'
              'us'
            when 'spanish'
              'es'
            when 'french'
              'fr'
            when 'german'
              'de'
            when 'italian'
              'it'
            when 'dutch'
              'bq'
            when 'turkish'
              'tr'
            when 'thai'
              'th'
            when 'portuguese'
              'br'
            when 'japanese'
              'jp'
            when 'korean'
              'kr'
            when 'arabic'
              'eg'
            when 'ukrainian'
              'ua'
            when 'romanian'
              'ro'
            when 'belarusian'
              'be'
            when 'swedish'
              'se'
            when 'hebrew'
              'is'
            when 'czech'
              'cz'
            when 'polish'
              'pl'
            when 'danish'
              'dk'
            when 'finnish'
              'fi'
            when '', 'unknown'
              ''
            else
              raise "Language error '#{language}'"
    end
  end
end
