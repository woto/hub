# frozen_string_literal: true

class TransactionDecorator < ApplicationDecorator

  def transaction_group_kind
    h.t(super)
  end

  def amount
    h.tag.mark do
      decorate_money(super, currency)
    end
  end

  def credit_code
    h.badge(status: super)
  end

  def debit_code
    h.badge(status: super)
  end

  def debit_amount
    h.capture do
      if h.current_user.role.in?(['admin', 'manager']) || h.current_user.account_ids.include?(object['_source']['debit_id'])
        h.concat(
          h.tag.mark do
            h.concat(("#{decorate_money((object['_source']['debit_amount'].to_d - object['_source']['amount'].to_d).to_f.round(2), currency)} + "))
            h.concat(("#{decorate_money(object['_source']['amount'].to_d, currency)} = "))
          end
        )
        h.concat(h.tag.div h.tag.mark(decorate_money(super, currency)))
      end
    end
    # h.tag.mark do
    #   decorate_money(super, currency)
    # end
  end

  def credit_amount
    h.capture do
      if h.current_user.role.in?(['admin', 'manager']) || h.current_user.account_ids.include?(object['_source']['credit_id'])
        h.concat(
          h.tag.mark do
            h.concat(("#{decorate_money((object['_source']['credit_amount'].to_d + object['_source']['amount'].to_d).to_f.round(2), currency)} - "))
            h.concat(("#{decorate_money(object['_source']['amount'].to_d, currency)} = "))
          end
        )
        h.concat(h.tag.div h.tag.mark(decorate_money(super, currency)))
      end
    end
    # h.tag.mark do
    #   decorate_money(super, currency)
    # end
  end
end
