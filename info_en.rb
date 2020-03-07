class InfoEn < ApplicationRecord
  belongs_to :info_type_en, foreign_key: 'info_type_id', optional: true
  belongs_to :info, foreign_key: 'id'

  before_save do
    diff_attrs = %w(title is_show source description)
    assign_attributes info.reload.attributes.reject { |k| !attributes[k].nil? && k.in?(diff_attrs) }
    self.description = ActionController::Base.helpers.strip_tags(description)
  end
end