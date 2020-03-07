class FreSpecial < ApplicationRecord
  has_many :fre_special_provinces, dependent: :destroy
  belongs_to :freight, optional: true
end
