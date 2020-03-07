class CrowdfundingPlayer < ApplicationRecord
  include Publishable
  belongs_to :crowdfunding
  belongs_to :player
  has_one :counter, class_name: 'CrowdfundingPlayerCounter'
  has_many :crowdfunding_orders, -> { order(created_at: :asc) }
  has_one :crowdfunding_rank, dependent: :destroy
  accepts_nested_attributes_for :player
  validates :player_id, :sell_stock, :stock_number,
            :stock_unit_price, :limit_buy, presence: true
  include CrowdfundingPlayerCountable
  has_many :crowdfunding_reports, -> { order(created_at: :desc) }, dependent: :destroy

  before_save do
    self.cf_money = stock_number * stock_unit_price
  end

  enum award_status: { init: 'init', waiting: 'waiting', completed: 'completed' }
  enum record_status: { unpublished: 'unpublished', success: 'success', failed: 'failed' }

  delegate :name, to: :player, allow_nil: true

  scope :published, -> { where(published: true) }
  scope :sorted, -> { order(created_at: :desc) }

  def order_fans
    ids = crowdfunding_orders.where(paid: true).pluck(:user_id).uniq
    { number: ids.length, users: User.find(ids) }
  end
end