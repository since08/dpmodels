class Info < ApplicationRecord
  include Publishable
  mount_uploader :image, InfoUploader
  include TopicCountable

  belongs_to :info_type
  has_one :info_en, foreign_key: 'id', dependent: :destroy
  accepts_nested_attributes_for :info_en, update_only: true
  belongs_to :race_tag, optional: true
  has_many :comments, as: :topic, dependent: :destroy
  has_many :topic_likes, as: :topic, dependent: :destroy
  has_one :counter, class_name: 'InfoCounter'
  has_one :topic_view_toggle, as: :topic, dependent: :destroy

  after_initialize do
    self.date ||= Date.current
  end

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
  end

  after_update do
    info_en || build_info_en
    info_en.save
  end

  default_scope { where(published: true).where(is_show: true) } unless ENV['CURRENT_PROJECT'] == 'dpcms'

  scope :published, -> { where(published: true) }
  scope :topped, -> { where(top: true) }

  def top!
    update(top: true)
  end

  def untop!
    update(top: false)
  end

  def image_thumb
    return '' if image.url.nil?

    image.url(:preview)
  end

  def big_image
    return '' if image.url.nil?

    image.url
  end

  def share_link
    ENV['H5_WEB_URL'] + '/' + "news/#{id}/zh"
  end
end
