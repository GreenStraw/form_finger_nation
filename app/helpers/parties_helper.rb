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
	 [{"value" => 5,  "text" => "05" }, {"value" => 6, "text" => "06" }, {"value" => 7, "text" => "07" }, 
	  {"value" => 8,  "text" => "08" }, {"value" => 9, "text" => "09" }, {"value" => 10, "text" => "10" },
	  {"value" => 11, "text" => "11" }, {"value" => 12,"text" => "12" }, {"value" => 1, "text" => "01" },
	  {"value" => 2,  "text" => "02" }, {"value" => 3, "text" => "03" }, {"value" => 4,"text" => "04" } ].map {|d| d.value, d.text}
  end
end