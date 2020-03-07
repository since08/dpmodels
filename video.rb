class Video < ApplicationRecord
  include Publishable
  include TopicCountable
  alias_attribute :title, :name

  mount_uploader :cover_link, VideoCoverUploader
  belongs_to :video_type, optional: true
  has_one :video_en, foreign_key: 'id', dependent: :destroy
  belongs_to :video_group, optional: true
  accepts_nested_attributes_for :video_en, update_only: true
  belongs_to :race_tag, optional: true
  has_many :comments, as: :topic, dependent: :destroy
  has_many :topic_likes, as: :topic, dependent: :destroy
  has_one :counter, class_name: 'VideoCounter'
  has_one :topic_view_toggle, as: :topic, dependent: :destroy

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
    if video_group.blank?
      create_video_group(name: name)
      self.is_main = true
    end
  end

  after_update do
    video_en || build_video_en
    video_en.save
  end

  default_scope { where(published: true).where(is_show: true) } unless ENV['CURRENT_PROJECT'] == 'dpcms'

  scope :published, -> { where(published: true) }
  scope :topped, -> { where(top: true) }
  scope :position_asc, -> { order(position: :asc).order(created_at: :desc) }

  def top!
    update(top: true)
  end

  def untop!
    update(top: false)
  end

  def image_thumb
    return '' if cover_link.url.nil?

    cover_link.url(:preview)
  end

  def big_image
    return '' if cover_link.url.nil?

    cover_link.url
  end

  def share_link
    ENV['H5_WEB_URL'] + '/' + "videos/#{id}/zh"
  end
end
