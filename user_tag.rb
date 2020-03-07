class UserTag < ApplicationRecord
  has_many :user_tag_map
  has_many :users, through: :user_tag_maps
end
