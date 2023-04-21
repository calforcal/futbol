require "csv"
require_relative './team_factory_module'  
require_relative './game_factory_module'
require_relative './game_teams_factory_module'

class StatTracker
  include TeamFactoryModule
  include GameFactoryModule
  include GameTeamsFactoryModule

  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = create_games(locations[:games])
    @teams = create_teams(locations[:teams])
    @game_teams = create_game_teams(locations[:game_teams])
  end

  
  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def percentage_ties
    total_games = @games.count
    total_ties = @games.count { |game| game.away_goals == game.home_goals }

    (total_ties.to_f / total_games.to_f).round(2)
  end

  def count_of_games_by_season
    game_seasons = @games.uniq { |game| game.season }
    seasons = game_seasons.map { |game| game.season }
    seasons.map do |season|
      [season, @games.count { |game| game.season == season }]
    end.to_h
  end

  def average_goals_per_game
    total_games = @games.count
    goals = @games.map { |game| game.total_goals }.sum 
    (goals.to_f / total_games.to_f).round(2)
  end

  def average_goals_by_season
    game_seasons = @games.uniq { |game| game.season }
    seasons = game_seasons.map { |game| game.season }
    seasons.map do |season|
      season_games = @games.select { |game| game.season == season }
      season_goals = season_games.map { |game| game.total_goals }.sum
      season_games_played = @games.count { |game| game.season == season }
      [season, (season_goals.to_f / season_games_played.to_f).round(2)]
    end.to_h
  end
end