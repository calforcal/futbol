require './lib/stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)

puts "Futbol Statistics:"
puts "-------------------"
puts "The Best Offense across all seasons -- #{stat_tracker.best_offense}"
puts "-------------------"
puts "The Lowest Scoring Visitor across all seasons -- #{stat_tracker.lowest_scoring_visitor}"
puts "-------------------"
puts "The Winningest Coach for the 2014-2015 season -- #{stat_tracker.winningest_coach("20142015")}"
puts "-------------------"
puts "The Most Accurate Team for the 2013-2014 season -- #{stat_tracker.most_accurate_team("20132014")}"