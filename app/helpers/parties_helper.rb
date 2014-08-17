module PartiesHelper
  def team_selects
    Team.order(:name).map {|team| [team.name, team.id]}
  end
  def venue_selects 
    Venue.order(:name).map {|venue| [venue.name, venue.id]}
  end
end