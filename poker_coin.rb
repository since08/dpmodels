class PokerCoin < ApplicationRecord
  belongs_to :user
  belongs_to :typeable, polymorphic: true, optional: true
  belongs_to :orderable, polymorphic: true, optional: true
  include PokerCoinDeduction

  after_create do
    user.increase_poker_coins(number)
  end

  # resource 对应的是PokerCoin所关联的typeable
  def self.total_coin_of_the_type(resource, user)
    where(typeable: resource).where(user: user).sum(:number)
  end
end
