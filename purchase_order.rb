=begin
+----------------+--------------+------+-----+----------+----------------+
| Field          | Type         | Null | Key | Default  | Extra          |
+----------------+--------------+------+-----+----------+----------------+
| id             | int(11)      | NO   | PRI | NULL     | auto_increment |
| user_id        | int(11)      | YES  | MUL | NULL     |                |
| ticket_id      | int(11)      | YES  | MUL | NULL     |                |
| race_id        | int(11)      | YES  | MUL | NULL     |                |
| ticket_type    | varchar(30)  | YES  |     | e_ticket |                |
| email          | varchar(255) | YES  |     | NULL     |                |
| address        | varchar(255) | YES  |     | NULL     |                |
| consignee      | varchar(50)  | YES  |     | NULL     |                |
| mobile         | varchar(50)  | YES  |     | NULL     |                |
| order_number   | varchar(30)  | YES  | UNI | NULL     |                |
| price          | int(11)      | NO   |     | NULL     |                |
| original_price | int(11)      | NO   |     | NULL     |                |
| status         | varchar(30)  | YES  | MUL | unpaid   |                |
| created_at     | datetime     | NO   |     | NULL     |                |
| updated_at     | datetime     | NO   |     | NULL     |                |
+----------------+--------------+------+-----+----------+----------------+
=end
class PurchaseOrder < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :ticket
  belongs_to :user_extra
  has_one :snapshot, class_name: OrderSnapshot
  has_many :syslogs, as: :operation, class_name: AdminSysLog
  has_many :wx_bills, primary_key: :order_number, foreign_key: :out_trade_no
  has_many :bills, primary_key: :order_number, foreign_key: :order_number
  belongs_to :invite_person, class_name: 'InviteCode', foreign_key: :invite_code, primary_key: :code, optional: true
  include DeductionResult

  validates :order_number, presence: true
  enum status: { unpaid: 'unpaid',
                 paid: 'paid',
                 delivered: 'delivered',
                 completed: 'completed',
                 canceled: 'canceled' }

  after_initialize do
    self.order_number ||= Services::UniqueNumberGenerator.call(PurchaseOrder)
  end

  after_create do
    create_snapshot(race.to_snapshot)
  end

  after_update do
    Notification.notify_order(self) if status_changed? && !unpaid?
  end

  scope :formal_order, -> { where.not(status: 'canceled') }

  def self.purchased?(user_id, race_id)
    where(user_id: user_id).where(race_id: race_id).formal_order.exists?
  end

  def self.purchased_order(user_id, race_id)
    where(user_id: user_id).where(race_id: race_id).formal_order.first
  end

  def self.unpaid_one_day_ago
    unpaid.where('created_at < ?', 1.day.ago)
  end

  def self.delivered_15_days
    delivered.where('delivery_time < ?', 15.days.ago)
  end

  def max_deduction_poker_coins
    # 用户总的扑客币数量
    user_account = user.counter.total_poker_coins
    max_deduction = price * PokerCoinDiscount.first.discount * 100
    user_account > max_deduction ? max_deduction : user_account
  end
end
