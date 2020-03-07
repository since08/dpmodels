class PlayerImage < ApplicationRecord
  belongs_to :player
  mount_uploader :image, PlayerLogoUploader
end
