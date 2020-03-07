class Photo < ApplicationRecord
  belongs_to :user, polymorphic: true

  validates :image, presence: true
  mount_uploader :image, PhotoUploader
end
