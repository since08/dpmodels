class ProductRefundImage < ApplicationRecord
  mount_uploader :image, RefundUploader
  belongs_to :product_refund

  def image_path
    return '' if image.url.nil?

    image.url
  end
end
