class TemplateType < ApplicationRecord
  has_many :reply_templates, foreign_key: :type_id, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
