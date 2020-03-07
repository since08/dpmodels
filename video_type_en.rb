class VideoTypeEn < ApplicationRecord
  has_many :video_ens, foreign_key: 'video_type_id', dependent: :destroy
  belongs_to :video_type, foreign_key: 'id'

  before_save do
    diff_attrs = %w(name)
    assign_attributes video_type.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
  end
end
