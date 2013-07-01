module GamesHelper
  def joined?(user, game)
    !power_for_user(user, game).nil?
  end

  def power_for_user(user, game)
    user.power_assignments.where(game_id: game.id).first
  end
end
