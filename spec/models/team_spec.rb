require 'spec_helper'

describe Team do
  before(:each) do
    @team = Fabricate(:team)
    @user = Fabricate(:user)
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

  describe "set_default_image_url" do
    context "when team is created" do
      it "should default image_url" do
        new_team = Fabricate(:team)
        expect(new_team.image_url).to eq(new_team.sport.image_url)
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
