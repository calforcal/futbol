require './lib/game'

RSpec.describe Game do
  describe "#initialize/1" do
    it "exists and has attributes" do
      details = {
        game_id: "12345",
        season: "2023",
        home_goals: "3",
        away_goals: "2"
      }
      
      game = Game.new(details)

      expect(game).to be_a(Game)
      expect(game.game_id).to eq("12345")
      expect(game.season).to eq("2023")
      expect(game.home_goals).to eq("3")
      expect(game.away_goals).to eq("2")
      expect(game.total_goals).to eq(5)
    end
  end
end