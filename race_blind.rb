class RaceBlind < ApplicationRecord
  belongs_to :race
  has_one :race_blind_en, foreign_key: :id, dependent: :destroy
  accepts_nested_attributes_for :race_blind_en, update_only: true
  after_update { race_blind_en&.save }

  validates :level, numericality: { greater_than: 0 }
  validates :content, presence: true, if: :blind_content?

  enum blind_type: [:blind_struct, :blind_content]
  scope :level_asc, -> { order(level: :asc).order(blind_type: :asc) }
  scope :position_asc, -> { order(position: :asc).order(level: :asc) }
end
