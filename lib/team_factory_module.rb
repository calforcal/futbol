require_relative './team'
module TeamFactoryModule
  def create_teams(team_path)
    teams = CSV.open team_path, headers: true, header_converters: :symbol
      teams.map do |team|
        details = {
          team_id: team[:team_id],
          franchise_id: team[:franchiseid],
          team_name: team[:teamname],
          abbreviation: team[:abbreviation],
          stadium: team[:stadium],
          link: team[:link]
        }
        Team.new(details)
      end
  end
end