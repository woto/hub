module AccountIdentifiable
  extend ActiveSupport::Concern

  class_methods do
    def for_user(user, code, currency)
      user.accounts.find_or_create_by!(code: code, currency: currency)
    end

    # def for_advertiser(advertiser, code, currency)
    #   advertiser.accounts.find_or_create_by!(code: code, currency: currency)
    # end

    def for_subject(identifier, code, currency)
      Subject.find_or_create_by!(identifier: identifier)
             .accounts.find_or_create_by!(code: code, currency: currency)
    end

    # def for_admitad(identifier, code, currency)
    #   for_subject(identifier, code, currency)
    # end
    #
    # def for_yandex(identifier, code, currency)
    #   for_subject(identifier, code, currency)
    # end
    #
    # def for_person(identifier, code, currency)
    #   for_subject(identifier, code, currency)
    # end
    #
    # def for_advego(identifier, code, currency)
    #   for_subject(identifier, code, currency)
    # end
  end
end
