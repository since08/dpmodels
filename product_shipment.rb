class ProductShipment < ApplicationRecord
  belongs_to :express_code, optional: true
  belongs_to :product_order
  has_many :product_shipment_with_order_items, dependent: :destroy
end