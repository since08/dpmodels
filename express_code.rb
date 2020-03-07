class ExpressCode < ApplicationRecord
  has_many :product_shipments

  default_scope { published_lists } unless ENV['CURRENT_PROJECT'] == 'dpcms'

  def self.published_lists
    where(published: true)
  end

  def toggle_status
    published? ? unpublished : published!
  end

  def published!
    update(published: true)
  end

  def unpublished
    update(published: false)
  end
end
