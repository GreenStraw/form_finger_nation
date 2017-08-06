module PartiesHelper
  def team_selects
    Team.order(:name).map {|team| [team.name, team.id]}
  end
  def venue_selects 
    Venue.order(:name).map {|venue| [venue.name, venue.address]}
  end
  def reservations_include?(party, user)
    user.party_reservations.where(user_id: user.id, party_id: party.id).first.blank? ? false : true
  end
  def timeOfParty
   [{value: "5",  text: "05" },
    {value: "8",  text: "08" },
    {value: "11", text: "11" },
    {value: "2",  text: "02" }].map {|d| d}
  end
end