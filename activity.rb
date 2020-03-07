class Activity < ApplicationRecord
  mount_uploader :pushed_img, ActivityUploader
  mount_uploader :banner, ActivityUploader

  has_one :activity_en, foreign_key: :id, dependent: :destroy
  accepts_nested_attributes_for :activity_en, update_only: true

  after_initialize do
    self.activity_time ||= Date.current
    self.start_push ||= Date.current
    self.end_push ||= Date.current
  end

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
  end

  after_update { activity_en&.save }

  enum push_type: { once: 'once', once_a_day: 'once_a_day' }

  def push!
    update(pushed: true)
  end

  def unpush!
    update(pushed: false)
  end

  def preview_banner
    return '' if banner.url.nil?

    banner.url(:sm)
  end

  def preview_pushed_img
    return '' if pushed_img.url.nil?

    pushed_img.url(:sm)
  end
end
