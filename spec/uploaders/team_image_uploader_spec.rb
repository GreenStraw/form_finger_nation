require 'spec_helper'

describe TeamImageUploader do
  before (:each) do
    @team = Fabricate(:team)
  end
  describe 'store_dir' do
    context "team store_dir" do
      it 'should be images/#{model.class.to_s.underscore}/#{model.id}' do
        expect(@team.image_url.store_dir).to eq('images/team/' + @team.id.to_s)
      end
    end
  end

  describe 'default_url' do
    context 'team default_url' do
      it 'should return ActionController::Base.helpers.asset_path("placeholder.png")' do
        expect(@team.image_url.default_url).to eq(ActionController::Base.helpers.asset_path("placeholder.png"))
      end
    end
  end
end
