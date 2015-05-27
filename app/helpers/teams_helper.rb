module TeamsHelper
  def sport_selects 
    Sport.order(:name).map {|team| [team.name, team.id]}
  end
end