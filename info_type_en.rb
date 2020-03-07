class InfoTypeEn < ApplicationRecord
  has_many :info_ens, foreign_key: 'info_type_id', dependent: :destroy
  belongs_to :info_type, foreign_key: 'id'

  before_save do
    diff_attrs = %w(name)
    assign_attributes info_type.reload.attributes.reject { |k| attributes[k].present? && k.in?(diff_attrs) }
  end
end