class AlbumPhoto < ApplicationRecord
  mount_uploader :image, PhotoUploader
  belongs_to :album, optional: true
end