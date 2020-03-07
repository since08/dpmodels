class InviteCode < ApplicationRecord
  # 生成邀请码，唯一性
  before_create :generate_code
  validates :name, presence: true, uniqueness: true
  has_many :orders, class_name: 'PurchaseOrder', foreign_key: :invite_code, primary_key: :code
  has_many :offline_race_orders

  validates :coupon_number, presence: true, if: :check_me

  def check_me
    if coupon_type.eql?('rebate') && (coupon_number <= 0 || coupon_number >= 100)
      errors.add(:coupon_number, '输入的数值必须是0 ～ 100之间的整数')
    end
    if coupon_type.eql?('reduce') && (coupon_number <= 0)
      errors.add(:coupon_number, '输入的数值必须是大于0的整数')
    end
    true
  end

  enum coupon_type: { no_discount: 'no_discount',
                      rebate: 'rebate',
                      reduce: 'reduce' }

  def success_count
    orders.where.not(status: %w(unpaid canceled)).count
  end

  def offline_count
    offline_race_orders.count
  end

  def total_fee
    app_fee + offline_fee
  end

  def app_fee
    orders.where.not(status: %w(unpaid canceled)).sum('price')
  end

  def offline_fee
    offline_race_orders.sum('price')
  end

  protected

  def generate_code
    self.code = loop do
      random_code = ('A'..'Z').to_a.sample(4).join
      break random_code unless InviteCode.exists?(code: random_code)
    end
  end
end
