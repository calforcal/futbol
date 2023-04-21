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

  def highest_total_score
    total = @games.max_by do |game|
      game.total_goals
    end
    total.total_goals
  end

  def lowest_total_score
    lowest_total = @games.min_by do |game|
      game.total_goals
    end
    lowest_total.total_goals
  end

  def percentage_home_wins
    home_wins = @games.count do |game|
      game.home_goals > game.away_goals
    end 
    percent = home_wins / games.count.to_f
    percent.round(2)
  end

  def percentage_visitor_wins
    away_wins = @games.count do |game|
      game.away_goals > game.home_goals
    end 
    percent = away_wins / games.count.to_f
    percent.round(2)
  end
end