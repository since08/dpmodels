class RaceScheduleEn < ApplicationRecord
  belongs_to :race_schedule, foreign_key: :id

  before_save do
    diff_attrs = %w(schedule updated_at created_at)
    attrs = race_schedule.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
    assign_attributes attrs
  end
end
