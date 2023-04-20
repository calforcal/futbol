require "csv"
require './lib/team_factory_module'  
require_relative './game_factory_module'
require './lib/team'

class StatTracker
  include TeamFactoryModule
  include GameFactoryModule

  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = create_games(locations[:games])
    @teams = create_teams(locations[:teams])
    @game_teams = create_game_teams(locations[:game_teams])
  end

  
  def self.from_csv(locations)
    StatTracker.new(locations)
  end
end