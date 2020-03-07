class ProductRefund < ApplicationRecord
  belongs_to :product_refund_type
  has_many :product_refund_images, dependent: :destroy
  has_many :product_refund_details, dependent: :destroy
  belongs_to :product_order

  before_create do
    self.refund_number = SecureRandom.hex(8)
  end

  enum status: { open: 'open', close: 'close', 'completed': 'completed' }

  def close_all!
    close!
    product_refund_details.each do |item|
      item.product_order_item.close!
    end
  end

  def complete_all!
    completed!
    product_refund_details.each do |item|
      item.product_order_item.completed!
    end
  end
end
