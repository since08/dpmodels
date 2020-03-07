class RaceExtraEn < ApplicationRecord
  belongs_to :race_extra, foreign_key: :id

  before_save do
    self.blind_memo = ActionController::Base.helpers.strip_tags(blind_memo)
    self.schedule_memo = ActionController::Base.helpers.strip_tags(schedule_memo)
    self.id      = race_extra.id
    self.race_id = race_extra.race_id
  end
end
