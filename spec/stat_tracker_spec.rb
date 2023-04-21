require "spec_helper"

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
end