class Game
  attr_reader :season, :game_id, :home_goals, :away_goals, :total_goals
  
  def initialize(details)
    @game_id = details[:game_id]
    @season = details[:season]
    @home_goals = details[:home_goals]
    @away_goals = details[:away_goals]
    @total_goals = details[:away_goals].to_i + details[:home_goals].to_i
  end
end