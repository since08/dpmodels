class VideoEn < ApplicationRecord
  belongs_to :video_type_en, foreign_key: 'video_type_id', optional: true
  belongs_to :video, foreign_key: 'id'

  before_save do
    diff_attrs = %w(name description title_desc is_show)
    assign_attributes video.reload.attributes.reject { |k| !attributes[k].nil? && k.in?(diff_attrs) }
    self.description = ActionController::Base.helpers.strip_tags(description)
  end
end
