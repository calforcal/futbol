
require_relative "spec_helper"

RSpec.describe StatTracker do
  describe '#initialize' do
    it 'exists' do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './fixture/game_teams_fixture.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      new_stat_tracker = StatTracker.new(locations)
      expect(new_stat_tracker).to be_a(StatTracker)
    end
  end

  describe "#module/create_games/1" do
    it "accepts a CSV and creates an Array of Game Objects" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      game1 = Game.new({game_id: "2012030221", season: "20122013", home_goals: "3", away_goals: "2"})
      game2 = Game.new({game_id: "2012030222", season: "20122013", home_goals: "3", away_goals: "2"})
      game3 = Game.new({game_id: "2012030223", season: "20122013", home_goals: "1", away_goals: "2"})
      stat_tracker = StatTracker.from_csv(locations)
      allow(stat_tracker).to receive(:games).and_return([game1, game2, game3])

      expect(stat_tracker.games).to be_a(Array)
      expect(stat_tracker.games.first).to be_a(Game)
      expect(stat_tracker.games[0].away_goals).to eq("2")
      expect(stat_tracker.games[1].game_id).to eq("2012030222")
      expect(stat_tracker.games[2].total_goals).to eq(3)
    end
  end
  
  describe "#highest_total_score" do
    it "returns the highest sum of the winning and losing teams’ scores" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)      
      expect(stat_tracker.highest_total_score).to eq(11)
    end
  end

  describe "#lowest_total_score" do
    it "returns the lowest sum of the winning and losing teams’ scores" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.lowest_total_score).to eq(0)
    end
  end

  describe "#percentage_ties" do
    it "can return the percentage ties" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
    
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.percentage_ties).to eq(0.20)
    end
  end

  describe "#count_of_games_by_season" do
    it "can return the count of games by season" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expected = {"20122013"=>806, "20132014"=>1323, "20142015"=>1319, "20152016"=>1321, "20162017"=>1317, "20172018"=>1355}
      expect(stat_tracker.count_of_games_by_season).to eq(expected)
    end
  end      

  describe "#percentage_home_wins" do
    it "returns Percentage of games that a home team has won (rounded to the nearest 100th)" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.percentage_home_wins).to eq(0.44)
    end
  end

  describe "#average_goals_per_game" do
    it "can return the average goals per game for all games" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.average_goals_per_game).to eq(4.22)
    end
  end

  describe "#percentage_visitor_wins" do
    it "returns Percentage of games that a home team has won (rounded to the nearest 100th)" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }   
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.percentage_visitor_wins).to eq(0.36)
    end
  end
  
  describe "#average_goals_by_season" do
    it "can return the average goals per game per season" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expected = {"20122013"=>4.12, "20132014"=>4.19, "20142015"=>4.14, "20152016"=>4.16, "20162017"=>4.23, "20172018"=>4.44}
      expect(stat_tracker.average_goals_by_season).to eq(expected)
    end
  end

  describe "#count_of_teams" do
    it "can count total number of teams in the data" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.count_of_teams).to eq(32)
    end
  end

  describe "#highest_scoring_vistor" do
    it "can name the team with the highest average score per game when they are away" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end
  end

  describe "#best_offense" do
    it "returns name of the team with the highest average number of goals scored per game across all seasons" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.best_offense).to eq("Reign FC")
    end
  end
  
  describe "#lowest_scoring_vistor" do
    it "can name the team with the lowest average score per game when they are away" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
    end
  end

  describe "#worst_offense" do
    it "returns name of the team with the lowest average number of goals scored per game across all seasons" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.worst_offense).to eq("Utah Royals FC")
    end
  end
  
  describe "#highest_scoring_home_team" do
    it "can name the team with the highest average score per game when they are home" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.highest_scoring_home_team).to eq("Reign FC")
    end
  end
  
  describe "#most_accurate_team" do
    it "can find the most accurate team for a specific season based on shot to goal ratio" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      
      expect(stat_tracker.most_accurate_team("20132014")).to eq("Real Salt Lake")
    end
  end
  
  describe "#least_accurate_team" do
    it "can find the least accurate team for a specific season based on shot to goal ratio" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.least_accurate_team("20132014")).to eq("New York City FC")
    end
  end

  describe "#most_tackles" do
    it "can find the name of the team with the most tackles in a specfic season" do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = 
      {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      stat_tracker = StatTracker.from_csv(locations)
      expect(stat_tracker.most_tackles("20132014")).to eq("FC Cincinnati")
    end
  end
end
