class ProductShipmentWithOrderItem < ApplicationRecord
  belongs_to :product_order_item
  belongs_to :product_shipment
end