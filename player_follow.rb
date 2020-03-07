class PlayerFollow < ApplicationRecord
  belongs_to :user
  belongs_to :player, counter_cache: :follows_count

  def self.followed?(user_id, player_id)
    where(user_id: user_id).where(player_id: player_id).exists?
  end
end
