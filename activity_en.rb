class ActivityEn < ApplicationRecord
  mount_uploader :pushed_img, ActivityUploader
  mount_uploader :banner, ActivityUploader
  belongs_to :activity, foreign_key: :id

  enum push_type: { once: 'once', once_a_day: 'once_a_day' }

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
    reject_attrs = %w(banner pushed_img link tag title description created_at updated_at)
    attrs = activity.reload.attributes.reject { |k| k.in?(reject_attrs) }
    assign_attributes attrs
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
