# +-------------+----------+------+-----+---------+----------------+
# | Field       | Type     | Null | Key | Default | Extra          |
# +-------------+----------+------+-----+---------+----------------+
# | id          | int(11)  | NO   | PRI | NULL    | auto_increment |
# | race_id     | int(11)  | YES  | MUL | NULL    |                |
# | description | text     | YES  |     | NULL    |                |
# | created_at  | datetime | NO   |     | NULL    |                |
# | updated_at  | datetime | NO   |     | NULL    |                |
# +-------------+----------+------+-----+---------+----------------+
class RaceDescEn < ApplicationRecord
  belongs_to :race_en, foreign_key: :race_id

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
    self.schedules = ActionController::Base.helpers.strip_tags(schedules)
  end
end
