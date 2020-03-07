class OfflineRaceOrder < ApplicationRecord
  belongs_to :invite_code, optional: true

  validates :invite_code_id, :name, :ticket, presence: true
end
