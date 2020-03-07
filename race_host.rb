class RaceHost < ApplicationRecord
  has_many :races

  validates :name, uniqueness: true, presence: true
  before_validation do
    self.name = name.strip
  end
end
