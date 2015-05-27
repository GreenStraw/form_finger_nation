require 'spec_helper'

describe Team do
  before(:each) do
    @team = Fabricate(:team)
    @user = Fabricate(:user)
  end

  describe "self.ordered_teams(teams)" do
    before {
      @nfl = Sport.new(name: 'NFL')
      @soccer = Sport.new(name: 'SOCCER')
      @test = Sport.new(name: 'TEST')
      Sport.stub(:all).and_return([@test, @soccer, @nfl])

      @nfl1 = Team.new(name: 'nfl1', sport: @nfl)
      @nfl2 = Team.new(name: 'nfl2', sport: @nfl)
      @soccer1 = Team.new(name: 'soccer1', sport: @soccer)
      @soccer2 = Team.new(name: 'soccer2', sport: @soccer)
      @test1 = Team.new(name: 'test1', sport: @test)
      @test2 = Team.new(name: 'test2', sport: @test)
      Team.stub(:all).and_return([@soccer1, @soccer2, @nfl1, @nfl2, @test1, @test2])
      Sport.should_receive(:ordered_sports).and_return({"NFL" => [@nfl1, @nfl2], "SOCCER" => [@soccer1, @soccer2], "TEST" => [@test1, @test2]})
    }
    it "should return [@nfl1, @nfl2, @soccer1, @soccer2, @test1, @test2]" do
      Team.ordered_teams(Team.all).should == {"NFL" => [@nfl1, @nfl2], "SOCCER" => [@soccer1, @soccer2], "TEST" => [@test1, @test2]}
    end
  end

  describe 'admins' do
    context 'current user has role' do
      before {
        @user.add_role(:team_admin, @team)
      }
      it "should return user" do
        expect(@team.admins).to eq([@user])
      end
    end

    context 'current user does not have role' do
      it "should return empty array" do
        expect(@team.admins).to eq([])
      end
    end
  end
end

# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_url   :string(255)
#  information :text
#  college     :boolean          default(FALSE)
#  sport_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
