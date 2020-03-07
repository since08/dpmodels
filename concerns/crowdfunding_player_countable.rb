module CrowdfundingPlayerCountable
  extend ActiveSupport::Concern
  included do
    after_create :create_counter
  end
end