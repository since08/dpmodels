class Release < ApplicationRecord
  validates :keywords, presence: true, uniqueness: true
end
