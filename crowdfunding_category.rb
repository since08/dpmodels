class CrowdfundingCategory < ApplicationRecord
  belongs_to :crowdfunding

  before_save do
    self.description = ActionController::Base.helpers.strip_tags(description)
  end

  before_create do
    max_pos = crowdfunding.crowdfunding_categories.maximum(:position)
    max_pos = max_pos.to_i.zero? ? 100000 : (max_pos + 100000)
    self.position = max_pos
  end
end