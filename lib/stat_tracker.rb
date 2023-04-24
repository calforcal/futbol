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

  def count_of_teams
    @teams.count
  end

  def best_offense
    team_avg_goals = {}
    @teams.each do |team|
      team_games = @games.select do |game| 
        game.home_team_id == team.team_id || game.away_team_id == team.team_id 
      end
      goals = team_games.map do |game| 
        if team.team_id == game.home_team_id
          game.home_goals.to_i
        elsif team.team_id == game.away_team_id
          game.away_goals.to_i
        end
      end.sum
      team_avg_goals[team.team_name] = goals.to_f / team_games.count
    end
    team_avg_goals.max_by do |team_name, avg_goals|
      avg_goals
    end.first
  end

  def worst_offense
    team_avg_goals = {}
    @teams.each do |team|
      team_games = @games.select do |game| 
        game.home_team_id == team.team_id || game.away_team_id == team.team_id 
      end
      goals = team_games.map do |game| 
        if team.team_id == game.home_team_id
          game.home_goals.to_i
        elsif team.team_id == game.away_team_id
          game.away_goals.to_i
        end
      end.sum
      team_avg_goals[team.team_name] = goals.to_f / team_games.count
    end
    team_avg_goals.min_by do |team_name, avg_goals|
      avg_goals
    end.first
  end

  def highest_scoring_visitor
    all_away_teams_goals_avg = {}
    teams.each do |team|
      team_games = games.select do |game|
        game.away_team_id == team.team_id
      end
      away_goals = team_games.map do |game|
        if team.team_id == game.away_team_id
          game.away_goals.to_i
        end
      end.sum
      all_away_teams_goals_avg[team.team_name] = away_goals / team_games.count.to_f
    end
    all_away_teams_goals_avg.max_by do |team_name, avg_away_goals|
      avg_away_goals
    end.first
  end

  def highest_scoring_home_team
    all_home_teams_goals_avg = {}
    teams.each do |team|
      team_games = games.select do |game|
        game.home_team_id == team.team_id
      end
      home_goals = team_games.map do |game|
        if team.team_id == game.home_team_id
          game.home_goals.to_i
        end
      end.sum
      all_home_teams_goals_avg[team.team_name] = home_goals / team_games.count.to_f
    end
    all_home_teams_goals_avg.max_by do |team_name, avg_home_goals|
      avg_home_goals
    end.first
  end

  def lowest_scoring_visitor
    all_away_teams_goals_avg = {}
    teams.each do |team|
      team_games = games.select do |game|
        game.away_team_id == team.team_id
      end
      away_goals = team_games.map do |game|
        if team.team_id == game.away_team_id
          game.away_goals.to_i
        end
      end.sum
      all_away_teams_goals_avg[team.team_name] = away_goals / team_games.count.to_f
    end
    all_away_teams_goals_avg.min_by do |team_name, avg_away_goals|
      avg_away_goals
    end.first
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

  def lowest_scoring_home_team
  grouped_teams = @game_teams.group_by { |game| game.team_id }
  avg_scores = {}
  grouped_teams.each do |team_id, games|
    home_games = games.select { |game| game.hoa == "home" }
    total_goals = home_games.sum { |game| game.goals.to_i }
    avg_score = total_goals.to_f / home_games.length
    avg_scores[team_id] = avg_score
  end
  team_id_with_lowest_score = nil
  lowest_score = Float::INFINITY
  avg_scores.each do |team_id, avg_score|
    if avg_score < lowest_score
      team_id_with_lowest_score = team_id
      lowest_score = avg_score
    end
  end
  team = @teams.find { |team| team.team_id == team_id_with_lowest_score }
  team.team_name
  end

  def winningest_coach(season)
    season_str = season
    season_games = @game_teams.select { |game| game.game_id.to_s[0,4] == season_str[0,4] }
    games_by_coach = season_games.group_by(&:head_coach)
    win_percentages = {}
    games_by_coach.each do |coach, games|
      win_count = games.count { |game| game.result == "WIN" }
      loss_count = games.count { |game| game.result == "LOSS" }
      tie_count = games.count { |game| game.result == "TIE" }
      total_games = win_count + loss_count + tie_count
      win_percentages[coach] = total_games >= 2 ? win_count.to_f / total_games : 0
    end
    winningest_coach = win_percentages.max_by { |coach, win_percentage| win_percentage }&.first
    return winningest_coach
  end

  def worst_coach(season)
    game_teams = []
    @game_teams.each do |game|
      if game.game_id.to_s[0,4] == season[0,4]
        game_teams << game
      end
    end
  
    games_coached = {}
    game_teams.each do |game|
      if games_coached[game.head_coach]
        games_coached[game.head_coach] << game
      else
        games_coached[game.head_coach] = [game]
      end
    end
    games_coached.each do |coach, games|
      wins = 0
      games.each do |game|
        if game.result == "WIN"
          wins += 1
        end
      end
      win_percentage = wins.to_f / games.length
      games_coached[coach] = win_percentage
    end
    worst_coach = nil
    worst_win_percentage = 1.0
    games_coached.each do |coach, win_percentage|
      if win_percentage < worst_win_percentage
        worst_coach = coach
        worst_win_percentage = win_percentage
      end
    end
    return worst_coach
  end

  def fewest_tackles(season)
    filtered_game_teams = filter_game_teams(generate_game_ids(games_by_season(season)))

    fewest_tackles_team_id = find_total_tackles_by_team(filtered_game_teams).min_by do |_, tackles|
      tackles
    end[0]

    get_team_name(fewest_tackles_team_id)
  end

  def filter_game_teams(game_ids)
    @game_teams.find_all do |game_team|
      game_ids.include?(game_team.game_id)
    end
  end

  def get_team_name(id)
    @teams.find do |team|
      team.team_id == id
    end.team_name
  end

  def generate_game_ids(games)
    games.map(&:game_id)
  end

  def games_by_season(season)
    @games.find_all do |game|
      game.season == season
    end
  end

  def find_total_tackles_by_team(game_teams)
    total_tackles_by_team = Hash.new(0)

    game_teams.each do |game_team|
      total_tackles_by_team[game_team.team_id] += game_team.tackles.to_i
    end

    total_tackles_by_team
  end

end


