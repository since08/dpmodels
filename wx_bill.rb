class WxBill < ApplicationRecord
  belongs_to :order, class_name: 'PurchaseOrder',
                     primary_key: :order_number,
                     foreign_key: :out_trade_no,
                     optional: true

  def self.success_bills
    where(result_code: 'SUCCESS').where(return_code: 'SUCCESS')
  end

  def self.fail_bills
    where.not(result_code: 'SUCCESS') || where.not(return_code: 'SUCCESS')
  end
end
