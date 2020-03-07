class ProductRefundDetail < ApplicationRecord
  belongs_to :product_refund
  belongs_to :product_order_item, optional: true
end
