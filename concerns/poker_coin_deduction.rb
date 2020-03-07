module PokerCoinDeduction
  extend ActiveSupport::Concern

  module ClassMethods
    def deduction(order, memo, number, sign = '-')
      poker_number = sign.eql?('-') ? -number : number
      PokerCoin.create(
        user_id: order&.user.id,
        orderable: order,
        memo: memo,
        number: poker_number
      )
    end
  end
end