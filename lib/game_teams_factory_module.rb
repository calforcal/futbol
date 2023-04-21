require_relative './game_teams'
module GameTeamsFactoryModule
  def create_game_teams(game_teams_path)
    games_teams = CSV.open game_teams_path, headers: true, header_converters: :symbol
    games_teams.map do |game_team|
      details = {
        game_id: game_team[:game_id],
        team_id: game_team[:team_id],
        hoa: game_team[:hoa],
        result: game_team[:result],
        settled_in: game_team[:settled_in],
        head_coach: game_team[:head_coach],
        goals: game_team[:goals],
        shots: game_team[:shots],
        tackles: game_team[:tackles]
    }
    GameTeams.new(details)
    end
  end
end