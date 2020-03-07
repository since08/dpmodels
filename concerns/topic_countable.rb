module TopicCountable
  extend ActiveSupport::Concern
  included do
    after_create :create_counter
  end

  def increase_page_views
    counter.increment!(:page_views)
  end

  def increase_view_increment(by)
    counter.increment!(:view_increment, by)
  end

  def increase_likes
    counter.increment!(:likes)
  end

  def decrease_likes
    counter.decrement!(:likes)
  end

  def total_views
    counter.page_views + counter.view_increment
  end

  def total_likes
    counter.likes
  end
end




