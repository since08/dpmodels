class OptionType < ApplicationRecord
  belongs_to :product
  has_many :option_values, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :product_id }
end
