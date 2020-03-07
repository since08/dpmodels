class FreSpecialProvince < ApplicationRecord
  belongs_to :fre_special, optional: true
  belongs_to :province, optional: true
end
