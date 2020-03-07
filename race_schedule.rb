class RaceSchedule < ApplicationRecord
  belongs_to :race
  has_one :race_schedule_en, foreign_key: :id, dependent: :destroy
  accepts_nested_attributes_for :race_schedule_en, update_only: true

  after_update { race_schedule_en&.save }
  after_initialize do
    self.begin_time ||= Time.current
  end

  scope :default_order, -> { order(begin_time: :asc, schedule: :asc) }
  scope :default_asc, -> { order(begin_time: :asc, schedule: :asc) }
end
