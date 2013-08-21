module GamesHelper
  def game_index_list(params)
    if params.has_key? :scope
      return "#{params[:scope].capitalize} games"
    else
      return "Games"
    end
  end

  def pretty_print_phase(game)
    "#{game.current_state.season}, #{game.current_state.year} (#{game.phase_name})"
  end

  def pretty_print_duration(duration)
    # duration is in seconds
    days  = duration / (24 * 60 * 60)
    duration -= days.days

    hours = duration / (60 * 60)
    duration -= hours.hours

    minutes = duration / 60
    duration -= minutes.minutes

    parts = []
    parts << pluralize(days, 'day') if days > 0 
    parts << pluralize(hours, 'hour') if hours > 0 
    parts << pluralize(minutes, 'minutes') if minutes > 0

    return parts[0..-1].join ', '
  end
end
