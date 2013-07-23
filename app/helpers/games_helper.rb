module GamesHelper
  def game_index_list(params)
    if params.has_key? :scope
      return "#{params[:scope].capitalize} games"
    else
      return "Games"
    end
  end
end
