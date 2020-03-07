class TmpImage < ApplicationRecord
  mount_uploader :image, TmpImageUploader

  def image_path
    return '' if image.url.nil?

    image.url
  end
end