class Team
  attr_reader :team_id, :franchise_id, :team_name, :abbreviation, :stadium, :link
  def initialize(details)
    @team_id = details[:team_id]
    @franchise_id = details[:franchise_id]
    @team_name = details[:team_name]
    @abbreviation = details[:abbreviation]
    @stadium = details[:stadium]
    @link = details[:link]
  end
end