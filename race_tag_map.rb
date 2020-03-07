class RaceTagMap < ApplicationRecord
  belongs_to :data, polymorphic: true
  belongs_to :race_tag, optional: true
end
