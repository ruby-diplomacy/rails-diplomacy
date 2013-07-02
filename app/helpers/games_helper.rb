module GamesHelper
  def joined?(user, game)
    !power_for_user(user, game).nil?
  end
end
