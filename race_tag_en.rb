class RaceTagEn < ApplicationRecord
  belongs_to :race_tag, foreign_key: 'id'

  before_save do
    diff_attrs = %w(name updated_at created_at)
    attrs = race_tag.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
    assign_attributes attrs
  end
end
