class ProductShippingAddress < ApplicationRecord
  belongs_to :product_order

  def full_address
    province.to_s + city.to_s + area.to_s + address.to_s
  end
end