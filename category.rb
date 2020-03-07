class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true
  mount_uploader :image, CategoryUploader

  acts_as_nested_set counter_cache: :children_count

  def self.roots_collection
    roots.collect { |c| [c.name, c.id] }
  end

  def preview_image
    return '' if image.url.nil?

    image.url(:sm)
  end
end
