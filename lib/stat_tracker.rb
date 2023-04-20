require "csv"


class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = create_games(locations[:games])
    @teams = create_teams(locations[:teams])
    @game_teams = create_game_teams(locations[:game_teams])

  end

  def create_games(game_path)
    games = CSV.readlines game_path, headers: true, header_converters: :symbol
    games.each do |game|

      # p game
    end
  end

  def create_teams(team_path)
    teams = CSV.open team_path, headers: true, header_converters: :symbol
    teams.each do |team|
      # p team
    end
  end

  def create_game_teams(game_teams_path)
    game_teams = CSV.open game_teams_path, headers: true, header_converters: :symbol
    game_teams.each do |game_team|

    end
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end



end