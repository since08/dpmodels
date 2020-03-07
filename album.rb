class Album < ApplicationRecord
  has_many :photos, class_name: 'AlbumPhoto'
end