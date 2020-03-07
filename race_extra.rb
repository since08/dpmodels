class RaceExtra < ApplicationRecord
  belongs_to :race
  has_one :race_extra_en, foreign_key: :id, dependent: :destroy
  accepts_nested_attributes_for :race_extra_en, update_only: true

  after_update { race_extra_en&.save }
  before_save do
    self.blind_memo = ActionController::Base.helpers.strip_tags(blind_memo)
    self.schedule_memo = ActionController::Base.helpers.strip_tags(schedule_memo)
  end
end
