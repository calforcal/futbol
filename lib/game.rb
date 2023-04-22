class Game
  attr_reader :season, :game_id, :home_goals, :away_goals, :total_goals, :away_team_id, :home_team_id
  
  def initialize(details)
    @game_id = details[:game_id]
    @season = details[:season]
    @home_goals = details[:home_goals]
    @away_goals = details[:away_goals]
    @total_goals = details[:away_goals].to_i + details[:home_goals].to_i
    @away_team_id = details[:away_team_id]
    @home_team_id = details[:home_team_id]
  end
end