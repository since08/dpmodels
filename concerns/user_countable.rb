module UserCountable
  extend ActiveSupport::Concern
  included do
    after_create :create_counter
  end

  def increase_poker_coins(by)
    counter.increment!(:total_poker_coins, by)
  end
end




