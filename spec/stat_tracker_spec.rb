require "./spec/spec_helper"

RSpec.describe StatTracker do
  describe '#initialize' do
    it 'exists' do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
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
end