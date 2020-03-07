class RaceBlindEn < ApplicationRecord
  belongs_to :race_blind, foreign_key: :id

  before_save do
    diff_attrs = %w(content updated_at created_at)
    attrs = race_blind.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
    assign_attributes attrs
  end

  enum blind_type: [:blind_struct, :blind_content]
end
