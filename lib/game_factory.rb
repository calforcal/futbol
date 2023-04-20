def create_games(game_path)
  games = CSV.readlines game_path, headers: true, header_converters: :symbol
  games.map do |game|
    details = {
      game_id: game[:game_id],
      season: game[:season],
      home_goals: game[:home_goals],
      away_goals: game[:away_goals],
      total_goals: game[:away_goals].to_i + game[:home_goals].to_i
    }

    Game.new(details)
  end
end