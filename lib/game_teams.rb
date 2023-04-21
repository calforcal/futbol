class GameTeams
    attr_reader :game_id, :team_id, :hoa, :result, :settled_in, :head_coach, :goals, :shots, :tackles
  def initialize(details)
      @game_id = details[:game_id],
      @team_id = details[:team_id],
      @hoa = details[:hoa],
      @result = details[:result],
      @settled_in = details[:settled_in],
      @head_coach = details[:head_coach],
      @goals = details[:goals],
      @shots = details[:shots],
      @tackles = details[:tackles]
  end
end