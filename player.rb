=begin
+-------------------+--------------+------+-----+---------+----------------+
| Field             | Type         | Null | Key | Default | Extra          |
+-------------------+--------------+------+-----+---------+----------------+
| id                | int(11)      | NO   | PRI | NULL    | auto_increment |
| player_id         | varchar(32)  | YES  |     | NULL    |                |
| name              | varchar(255) | YES  |     |         |                |
| avatar            | varchar(100) | YES  |     | NULL    |                |
| gender            | varchar(255) | YES  |     | 0       |                |
| country           | varchar(255) | YES  |     |         |                |
| dpi_total_earning | int(11)      | YES  |     | NULL    |                |
| gpi_total_earning | int(11)      | YES  |     | NULL    |                |
| dpi_total_score   | int(11)      | YES  |     | NULL    |                |
| gpi_total_score   | int(11)      | YES  |     | NULL    |                |
| memo              | varchar(255) | YES  |     |         |                |
| created_at        | datetime     | NO   |     | NULL    |                |
| updated_at        | datetime     | NO   |     | NULL    |                |
| avatar_md5        | varchar(32)  | NO   |     |         |                |
+-------------------+--------------+------+-----+---------+----------------+
=end
class Player < ApplicationRecord
  mount_uploader :avatar, PlayerUploader
  mount_uploader :logo, PlayerLogoUploader
  has_many :race_ranks, -> { order(end_date: :desc) }
  has_many :crowdfunding_ranks, -> { order(end_date: :desc) }
  has_many :followed_user, -> { order(id: :desc) }, class_name: PlayerFollow
  attr_accessor :avatar_thumb
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_many :player_images, dependent: :destroy
  # after_update :crop_avatar

  validates :name, :country, presence: true
  validates :name, uniqueness: { scope: :country }

  before_save do
    self.player_id = SecureRandom.hex(4) if created_at.blank?
  end

  ransacker :year if ENV['CURRENT_PROJECT'] == 'dpcms'
  scope :earn_order, -> { order(dpi_total_earning: :desc) }

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  DEFAULT_AVATAR = "#{ENV['UPYUN_BUCKET_HOST']}/uploads/player/defalt_player_avatar.png".freeze
  def avatar_thumb
    return DEFAULT_AVATAR if avatar.thumb.url.nil?

    avatar.thumb.url + "?suffix=#{updated_at.to_i}"
  end

  def self.leaderboard
    @leaderboard ||= PlayerLeaderboard.new.ld
  end

  after_save :syn_leaderboard_score
  after_destroy :remove_leaderboard_member
  def syn_leaderboard_score
    Player.leaderboard.rank_members(id, dpi_total_earning)
  end

  def remove_leaderboard_member
    Player.leaderboard.remove_member id
  end

  def ranking
    Player.leaderboard.rank_for(id)
  end

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end
end
