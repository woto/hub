# frozen_string_literal: true

class ProfileForm
  include ActiveModel::Serialization
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Naming

  # class Language
  #   include ActiveModel::Model
  #   include ActiveModel::Attributes
  #   extend ActiveModel::Naming
  #
  #   attribute :language, :string
  #   validates :language, inclusion: { strict: true, allow_blank: true, allow_nil: true, in: [''] + Rails.application.config.global[:languages].map { |lng| lng[:english_name] } }
  # end

  class Messenger
    include ActiveModel::Model
    include ActiveModel::Attributes
    extend ActiveModel::Naming
    include ActiveModel::Serialization

    attribute :type
    attribute :value

    validates :type, presence: true
    validates :value, presence: true

    validates :type, inclusion: {
      in: Rails.application.config.global[:messengers].map { |msn| msn[:long] },
      message: ->(_, __) { I18n.t('select_messenger_type', scope: %i[activerecord errors messages]) }
    }
  end

  attr_accessor :name, :bio, :location, :languages, :messengers

  # attribute :name, :string
  # attribute :bio, :string
  # attribute :location, :string

  # attr_accessor :languages
  # attr_accessor :messengers

  validates :name, presence: true
  validates :bio, presence: true
  validates :location, presence: true
  validates :messengers, length: { minimum: 1 }
  validates :languages, length: {
    minimum: 2,
    message: ->(_, __) { I18n.t('select_language', scope: %i[activerecord errors messages]) }
  }

  # validates inclusion
  validate do
    unless (languages - ([''] + Rails.application.config.global[:languages].map { |lng| lng[:english_name] })).empty?
      errors.add(:languages, I18n.t('select language', scope: %i[activerecord errors messages]))
    end
  end

  def messengers_attributes=(attributes)
    @messengers = attributes.map do |_, v|
      Messenger.new(v)
    end
  end

  def initialize(*)
    super
    # TODO: it is a hack due we can not use like `attribute :messengers, :array`
    @messengers ||= []
  end

  def valid?(context = nil)
    super
    # TODO: nasty association validation
    errors.add(:base, 'nope') if @messengers.map(&:invalid?).any?
    errors.none?
  end

  def attributes
    {
      'name' => nil,
      'bio' => nil,
      'location' => nil,
      'messengers' => nil,
      'languages' => nil
    }
  end
end
