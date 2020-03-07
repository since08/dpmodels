class ProductImage < ApplicationRecord
  mount_uploader :filename, ProductImageUploader
  belongs_to :viewable, polymorphic: true
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  scope :position_asc, -> { order(position: :asc) }
  def preview
    return '' if filename.url.nil?

    filename.url(:sm)
  end

  def large
    return '' if filename.url.nil?

    filename.url(:lg)
  end
end
