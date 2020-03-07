class VariantOptionValue < ApplicationRecord
  belongs_to :variant
  belongs_to :option_value
  belongs_to :option_type
end
