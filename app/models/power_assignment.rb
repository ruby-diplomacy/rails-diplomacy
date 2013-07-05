class PowerAssignment < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  
  attr_accessible :power, :game_id

  validates :user, uniqueness: { scope: :game_id }

  after_update :check_game_ready

  def check_game_ready
    if self.game.powers.length == self.game.power_assignments.count and
      self.game.phase == Game::PHASES[:awaiting_players]

      self.game.progress_phase
    end
  end
end
