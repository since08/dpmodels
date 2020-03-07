class CrowdfundingPlayerCounter < ApplicationRecord
  belongs_to :crowdfunding_player
  belongs_to :crowdfunding
  before_create do
    self.crowdfunding = crowdfunding_player.crowdfunding
  end

  def quick_increment!(cf_order)
    increment!(:order_stock_number, cf_order.order_stock_number)
    increment!(:order_stock_money, cf_order.order_stock_money)
    increment!(:total_money, cf_order.total_money)
  end
end