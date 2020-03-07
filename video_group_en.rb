class VideoGroupEn < ApplicationRecord
  has_many :video_ens
  belongs_to :video_group, foreign_key: 'id'

  before_save do
    diff_attrs = %w(name)
    assign_attributes video_group.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
  end
end
