class Crowdfunding < ApplicationRecord
  has_one :race
  has_many :crowdfunding_players, dependent: :destroy
  has_many :poker_coins, as: :typeable, dependent: :destroy
  has_many :crowdfunding_orders
  has_many :crowdfunding_ranks, -> { order(ranking: :asc) }
  mount_uploader :master_image, CrowdfundingUploader
  include Publishable
  include CrowdfundingCountable
  after_create do
    create_default_category
  end

  belongs_to :race
  has_many :players
  has_many :crowdfunding_categories, -> { order(position: :asc) }, dependent: :destroy
  has_one :counter, class_name: 'CrowdfundingCounter'
  accepts_nested_attributes_for :crowdfunding_categories, allow_destroy: true
  validates :race_id, presence: true
  has_many :crowdfunding_reports, -> { order(created_at: :desc) }, dependent: :destroy

  after_initialize do
    self.expire_date ||= Date.current
    self.publish_date ||= Date.current
    self.award_date ||= Date.current
  end

  scope :published, -> { where(published: true) }
  scope :sorted, -> { order(created_at: :desc) }

  def preview_image
    return '' if master_image.url.nil?

    master_image.url(:sm)
  end

  def create_default_category
    crowdfunding_categories.create(name: '项目介绍', description: race&.race_desc&.description)
    %w(众筹概况 项目公告 投资风险).each { |name| crowdfunding_categories.create(name: name) }
  end

  def player_count
    crowdfunding_players.published.count
  end

  def cf_total_money
    crowdfunding_players.published.sum(:cf_money)
  end

  def cf_offer_money
    crowdfunding_players.published.sum { |item| item.counter.total_money }
  end
end
