class ProductOrder < ApplicationRecord
  belongs_to :user

  has_one :product_shipping_address, dependent: :destroy
  has_many :product_order_items, dependent: :destroy
  has_many :product_wx_bills, dependent: :destroy
  has_one :product_shipment, dependent: :destroy
  include DeductionResult

  PAY_STATUSES = %w(unpaid paid failed refund).freeze
  validates :pay_status, inclusion: { in: PAY_STATUSES }

  enum status: { unpaid: 'unpaid',
                 paid: 'paid',
                 delivered: 'delivered',
                 completed: 'completed',
                 canceled: 'canceled',
                 returning: 'returning',
                 returned: 'returned' }

  before_create do
    self.order_number = Services::UniqueNumberGenerator.call(ProductOrder)
  end

  default_scope { where(deleted: false) } unless ENV['CURRENT_PROJECT'] == 'dpcms'

  def cancel_order(reason = '取消订单')
    return if canceled?
    update(cancel_reason: reason, cancelled_at: Time.zone.now, status: 'canceled')
    product_order_items.each do |item|
      item.variant.increase_stock(item.number)
      next if item.variant.is_master?

      item.variant.product.master.increase_stock(item.number)
    end
    # 将扑客币的数量添加上去
    if deduction && deduction_result.eql?('success')
      PokerCoin.deduction(self, '商品订单返还扑客币', deduction_numbers, '+')
      deduction_success
    else
      true
    end
  end

  def delivered!
    update(status: 'delivered', delivered: true, delivered_time: Time.zone.now)
  end

  def completed!
    update(status: 'completed', completed_time: Time.zone.now)
  end

  def deleted!
    update(deleted: true)
  end

  def could_delete?
    canceled? || completed?
  end

  def self.unpaid_half_an_hour
    unpaid.where('created_at < ?', 30.minutes.ago)
  end

  def could_refund?
    paid? || (delivered? && delivered_time.present? && delivered_time > 15.days.ago)
  end

  def self.delivered_15_days
    delivered.where('delivered_time < ?', 15.days.ago)
  end

  # 是否可退现金
  def could_refund_cash?
    could_refund_cash_numbers.positive?
  end

  # 可退的现金
  def could_refund_cash_numbers
    final_price - refund_price
  end

  def could_refund_poker_coins?
    # 没有使用扑客币抵扣，那么程序直接去退现金
    return true if deduction_numbers.to_i <= 0
    # 使用了扑客币抵扣，并且扑客币都退完了，说明现金也退完了
    could_refund_poker_numbers.positive?
  end

  # 可退的扑客币
  def could_refund_poker_numbers
    deduction_numbers - refund_poker_coins
  end
end
