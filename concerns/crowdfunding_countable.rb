module CrowdfundingCountable
  extend ActiveSupport::Concern
  included do
    after_create :create_counter
  end

  def increase_page_views
    counter.increment!(:page_views)
  end
end