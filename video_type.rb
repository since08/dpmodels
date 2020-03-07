class VideoType < ApplicationRecord
  include Publishable

  has_many :videos, dependent: :destroy
  has_one  :video_type_en, foreign_key: 'id', dependent: :destroy
  accepts_nested_attributes_for :video_type_en, update_only: true

  after_update do
    video_type_en || build_video_type_en
    video_type_en.save
  end

  default_scope { where(published: true) } unless ENV['CURRENT_PROJECT'] == 'dpcms'
end
