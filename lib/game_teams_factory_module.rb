require_relative './game_teams'
module GameTeamsFactoryModule
  def create_game_teams(game_teams_path)
    games_teams = CSV.open game_teams_path, headers: true, header_converters: :symbol
    games_teams.map do |game_teams|
      details = {
        game_id: game_teams[:game_id],
        team_id: game_teams[:team_id],
        hoa: game_teams[:hoa],
        result: game_teams[:result],
        settled_in: game_teams[:settled_in],
        head_coach: game_teams[:head_coach],
        goals: game_teams[:goals],
        shots: game_teams[:shots],
        tackles: game_teams[:tackles]
    }
    GameTeams.new(details)
    end
  end
end