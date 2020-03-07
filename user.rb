# +---------------+--------------+------+-----+---------+----------------+
# | Field         | Type         | Null | Key | Default | Extra          |
# +---------------+--------------+------+-----+---------+----------------+
# | id            | int(11)      | NO   | PRI | NULL    | auto_increment |
# | user_uuid     | varchar(32)  | NO   | UNI | NULL    |                |
# | user_name     | varchar(32)  | YES  | UNI | NULL    |                |
# | nick_name     | varchar(32)  | YES  |     | NULL    |                |
# | password      | varchar(32)  | YES  |     | NULL    |                |
# | password_salt | varchar(255) | NO   |     |         |                |
# | gender        | int(11)      | YES  |     | 0       |                |
# | email         | varchar(64)  | YES  | UNI | NULL    |                |
# | mobile        | varchar(16)  | YES  | UNI | NULL    |                |
# | avatar        | varchar(255) | YES  |     | NULL    |                |
# | birthday      | date         | YES  |     | NULL    |                |
# | reg_date      | datetime     | YES  |     | NULL    |                |
# | last_visit    | datetime     | YES  |     | NULL    |                |
# | created_at    | datetime     | NO   |     | NULL    |                |
# | updated_at    | datetime     | NO   |     | NULL    |                |
# +---------------+--------------+------+-----+---------+----------------+

# 用户信息表
class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
  mount_uploader :avatar, AvatarUploader

  # 增加二级查询缓存，缓存过期时间六小时
  second_level_cache(version: 1, expires_in: 6.hours)

  attr_accessor :avatar_path

  # 关联关系
  has_one  :user_extra
  # 新增用户和实名为 多对1 的关系
  has_many :user_extras
  has_one  :weixin_user
  has_one  :test_user
  has_many :race_follows
  has_many :tickets
  has_many :purchase_orders
  has_many :product_orders
  has_many :orders, class_name: PurchaseOrder
  has_many :shipping_addresses, -> { order(default: :desc) }
  has_many :account_change_stats
  has_many :notifications
  has_many :comments
  has_many :replies
  has_many :topic_likes
  has_many :dynamics
  has_many :user_tag_maps
  has_many :user_tags, through: :user_tag_maps
  has_many :followed_players, -> { order(id: :desc) }, class_name: PlayerFollow
  accepts_nested_attributes_for :user_extra, update_only: true
  has_many :poker_coins, -> { order(id: :desc) }
  has_many :crowdfunding_orders, -> { order(created_at: :desc) }
  has_one :counter, class_name: 'UserCounter'

  enum status: { basic: 'basic', banned: 'banned' }

  # 刷新访问时间
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  # 上传图片给图片赋值的时候 创建图片路径
  def avatar=(value)
    super
    # rubocop:disable Style/GuardClause:52
    if avatar.file.present? && avatar.file.respond_to?(:path) && File.exist?(avatar.file.path)
      self.avatar_md5 = Digest::MD5.file(avatar.file.path).hexdigest
    end
  end

  def avatar_path
    avatar.url.blank? ? wx_avatar : avatar.url
  end

  def banned?
    role.eql?('banned')
  end

  def tester?
    @is_tester ||= test_user.present?
  end

  def official?
    role.eql?('official')
  end

  def self.official
    find_by!(role: 'official')
  end

  def blocked!
    update(blocked: true)
  end

  def unblocked!
    update(blocked: false)
  end

  def silenced!(reason, till)
    update(silenced: true,
           silence_at: Time.zone.now,
           silence_reason: reason,
           silence_till: till)
  end

  def silenced_and_till?
    silenced? && (silence_till > Time.zone.now)
  end

  def total_coins
    poker_coins.sum(:number)
  end
end
