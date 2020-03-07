class Bill < ApplicationRecord
  belongs_to :order, class_name: 'PurchaseOrder', primary_key: :order_number, foreign_key: :order_number

  def self.success_bills
    where(trade_status: 0)
  end

  def self.fail_bills
    where.not(trade_status: 0)
  end
end
