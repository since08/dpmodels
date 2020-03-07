module ProductCountable
  extend ActiveSupport::Concern
  included do
    after_create :create_counter
  end

  def increase_all_page_view
    counter.increment!(:all_page_view)
  end

  def increase_sales_volume(by)
    counter.increment!(:sales_volume, by)
  end

  def decrease_sales_volume(by)
    counter.decrement!(:sales_volume, by)
  end
end




