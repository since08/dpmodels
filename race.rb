=begin
+-----------------+--------------+------+-----+---------+----------------+
| Field           | Type         | Null | Key | Default | Extra          |
+-----------------+--------------+------+-----+---------+----------------+
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(256) | YES  |     | NULL    |                |
| seq_id          | bigint(20)   | NO   | UNI | 0       |                |
| logo            | varchar(256) | YES  |     | NULL    |                |
| prize           | varchar(255) | NO   |     |         |                |
| location        | varchar(256) | YES  |     | NULL    |                |
| begin_date      | date         | YES  | MUL | NULL    |                |
| end_date        | date         | YES  |     | NULL    |                |
| status          | int(11)      | NO   |     | 0       |                |
| created_at      | datetime     | NO   |     | NULL    |                |
| updated_at      | datetime     | NO   |     | NULL    |                |
| ticket_price    | int(11)      | YES  |     | 0       |                |
| published       | tinyint(1)   | YES  |     | 0       |                |
| ticket_sellable | tinyint(1)   | YES  |     | 1       |                |
| describable     | tinyint(1)   | YES  |     | 1       |                |
+-----------------+--------------+------+-----+---------+----------------+
=end
class Race < ApplicationRecord
  include Publishable
  mount_uploader :logo, RacePhotoUploader

  # 增加二级查询缓存，缓存过期时间六小时
  second_level_cache(version: 1, expires_in: 6.hours)

  has_many :race_follows
  has_many :race_ranks, -> { order(ranking: :asc) }
  has_many :crowdfunding_ranks, -> { order(ranking: :asc) }
  has_many :race_blinds
  has_many :tickets, -> { order(level: :asc) }
  has_many :race_orders, class_name: PurchaseOrder
  has_many :sub_races, class_name: 'Race', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Race', optional: true
  belongs_to :race_host, optional: true
  has_many :race_schedules
  has_one :race_extra, dependent: :destroy
  has_one :race_desc, dependent: :destroy
  accepts_nested_attributes_for :race_desc, update_only: true
  has_one :race_desc_en, dependent: :destroy
  accepts_nested_attributes_for :race_desc_en, update_only: true
  has_one :race_en, foreign_key: :id, dependent: :destroy
  accepts_nested_attributes_for :race_en, update_only: true

  validates :name, presence: true
  enum required_id_type: { any: 'any', chinese_id: 'chinese_id', 'passport_id': 'passport_id' }
  enum status: [:unbegin, :go_ahead, :ended, :closed]
  ransacker :status, formatter: proc { |v| statuses[v] } if ENV['CURRENT_PROJECT'] == 'dpcms'

  after_initialize do
    self.begin_date ||= Date.current
    self.end_date ||= Date.current
  end

  before_save do
    self.seq_id = Services::RaceSequencer.call(self) if begin_date_changed?
  end

  after_update { race_en&.save }

  scope :main, -> { where(parent_id: 0) }
  # 默认取已发布的赛事
  default_scope { where(published: true) } unless ENV['CURRENT_PROJECT'] == 'dpcms'
  # 近期赛事
  scope :recent_races, -> { where('end_date >= ?', Date.current).where.not(status: [2, 3]) }
  # 排序
  scope :date_asc, -> { order(begin_date: :asc).order(schedule_begin_time: :asc) }
  scope :begin_date_desc, -> { order(begin_date: :desc) }
  scope :seq_desc, -> { order(seq_id: :desc) }
  scope :seq_asc, -> { order(seq_id: :asc) }
  scope :ticket_sellable, -> { where(ticket_sellable: true) }

  # 获取指定条数的近期赛事 (5条)
  def self.limit_recent_races(numbers = 5)
    main.recent_races.limit(numbers).date_asc
  end

  def to_snapshot
    {
      race_id:      id,
      name:         name,
      logo:         preview_logo,
      location:     location,
      begin_date:   begin_date,
      end_date:     end_date
    }
  end

  def cancel_sell!
    update(ticket_sellable: false)
  end

  def sellable!
    update(ticket_sellable: true)
  end

  def preview_logo
    return '' if logo.url.nil?

    logo.url(:sm).to_s
  end

  def big_logo
    return '' if logo.url.nil?

    logo.url.to_s
  end

  def days
    (end_date - begin_date).to_i + 1
  end

  def main?
    parent_id.zero?
  end

  def ticket_status
    return 'end' if !ticket_sellable && tickets.present?

    return 'unsold' if unsold?

    return 'sold_out' if sold_out?

    'selling'
  end

  def unsold?
    tickets.blank? && sub_tickets.blank?
  end

  def sold_out?
    tickets.not_sold_out.blank? && sub_tickets.not_sold_out.blank?
  end

  def sub_tickets
    Ticket.where(race_id: sub_races.ids)
  end
end
