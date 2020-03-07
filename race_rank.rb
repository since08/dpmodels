=begin
+-----------+---------+------+-----+---------+----------------+
| Field     | Type    | Null | Key | Default | Extra          |
+-----------+---------+------+-----+---------+----------------+
| id        | int(11) | NO   | PRI | NULL    | auto_increment |
| race_id   | int(11) | YES  | MUL | NULL    |                |
| player_id | int(11) | YES  | MUL | NULL    |                |
| ranking   | int(11) | YES  |     | NULL    |                |
| earning   | int(11) | YES  |     | NULL    |                |
| score     | int(11) | YES  |     | NULL    |                |
+-----------+---------+------+-----+---------+----------------+
=end
class RaceRank < ApplicationRecord
  belongs_to :race
  belongs_to :player

  validates :player_id, :ranking, :earning, :score, presence: true
  validates :player_id, uniqueness: { scope: :race_id }

  # after_create do
  #   player.increment!(:dpi_total_earning, earning) if earning.positive?
  #   player.increment!(:dpi_total_score, score) if score.positive?
  # end

  before_save do
    self.end_date = race&.end_date
  end

  after_destroy do
    player.decrement!(:dpi_total_earning, earning) if earning.positive?
    player.decrement!(:dpi_total_score, score) if score.positive?
    player.syn_leaderboard_score
  end

  after_save do
    if player_id == player_id_was
      update_player_data
    else
      replace_player_data
    end
    player.syn_leaderboard_score
  end

  def update_player_data
    earning_d_val = earning - earning_was
    score_d_val   = score - score_was
    player.increment!(:dpi_total_earning, earning_d_val) unless earning_d_val.zero?
    player.increment!(:dpi_total_score, score_d_val) unless score_d_val.zero?
  end

  def replace_player_data
    player.increment!(:dpi_total_earning, earning) if earning.positive?
    player.increment!(:dpi_total_score, score) if score.positive?

    old_player = Player.find_by id: player_id_was
    return if old_player.nil?

    old_player.decrement!(:dpi_total_earning, earning_was) if earning_was.positive?
    old_player.decrement!(:dpi_total_score, score_was) if score_was.positive?
    old_player.syn_leaderboard_score
  end
end
