class CrowdfundingRank < ApplicationRecord
  belongs_to :race
  belongs_to :player
  belongs_to :crowdfunding
  belongs_to :crowdfunding_player

  before_save do
    amount = (earning - deduct_tax) * crowdfunding_player.sell_stock / 100
    amount = 0 if amount.negative?
    self.sale_amount = amount
    self.total_amount = platform_tax.zero? ? sale_amount : sale_amount * (1 - platform_tax / 100)
    self.unit_amount = total_amount / crowdfunding_player.stock_number
    self.end_date = race&.end_date
  end

  after_create do
    crowdfunding_player.waiting!
  end

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end
end
