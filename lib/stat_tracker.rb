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

  def most_accurate_team(season)
    season_games = @games.select do |game|
      game.season == season
    end
    season_game_teams = []
    season_games.each do |game|
      @game_teams.each do |game_team|
        if game.game_id == game_team.game_id
          season_game_teams << game_team
        end
      end
    end

    team_hash = @teams.map do |team|
      teams_games = season_game_teams.select { |game_team| game_team.team_id == team.team_id}
      team_shots = teams_games.map { |team_game| team_game.shots.to_i }.sum.to_f
      team_goals = teams_games.map { |team_game| team_game.goals.to_i }.sum.to_f
      [team.team_name, (team_shots / team_goals).round(2)]
    end.to_h

    min = 100
    best_team = ""
    team_hash.each_pair do |team, value|
      if value < min
        min = value
        best_team = team
      end
    end
    best_team
  end

  def least_accurate_team(season)
    season_games = @games.select { |game| game.season == season }
    season_game_teams = []
    season_games.each do |game|
      @game_teams.each do |game_team|
        if game.game_id == game_team.game_id
          season_game_teams << game_team
        end
      end
    end

    team_hash = @teams.map do |team|
      teams_games = season_game_teams.select { |game_team| game_team.team_id == team.team_id}
      team_shots = teams_games.map { |team_game| team_game.shots.to_i }.sum.to_f
      team_goals = teams_games.map { |team_game| team_game.goals.to_i }.sum.to_f
      [team.team_name, (team_shots / team_goals).round(2)]
    end.to_h

    max = 0
    worst_team = ""
    team_hash.each_pair do |team, value|
      if value > max
        max = value
        worst_team = team
      end
    end
    worst_team
  end

  def most_tackles(season)
    season_games = @games.select { |game| game.season == season }
    season_game_teams = []
    season_games.each do |game|
      @game_teams.each do |game_team|
        if game.game_id == game_team.game_id
          season_game_teams << game_team
        end
      end
    end

    team_hash = @teams.map do |team|
      teams_games = season_game_teams.select { |game_team| game_team.team_id == team.team_id}
      team_tackles = teams_games.map { |team_game| team_game.tackles.to_i }.sum.to_f
      [team.team_name, team_tackles]
    end.to_h

    max = 0
    best_team = ""
    team_hash.each_pair do |team, value|
      if value > max
        max = value
        best_team = team
      end
    end
    best_team
  end
end
