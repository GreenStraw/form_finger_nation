require 'spec_helper'

describe ImageUploader do
  before (:each) do
    @venue = Fabricate(:venue)
    @user = Fabricate(:user)
  end
  describe 'store_dir' do
    context "venue store_dir" do
      it 'should be images/#{model.class.to_s.underscore}/#{model.id}' do
        expect(@venue.image_url.store_dir).to eq('images/venue/' + @venue.id.to_s)
      end
    end

    context "user store_dir" do
      it 'should be images/#{model.class.to_s.underscore}/#{model.id}' do
        expect(@user.image_url.store_dir).to eq('images/user/' + @user.id.to_s)
      end
    end
  end

  describe 'default_url' do
    context 'venue default_url' do
      it 'should return ActionController::Base.helpers.asset_path("placeholder.png")' do
        expect(@venue.image_url.default_url).to eq(ActionController::Base.helpers.asset_path("placeholder.png"))
      end
    end

    context 'user default_url' do
      it 'should return ActionController::Base.helpers.asset_path("placeholder.png")' do
        expect(@user.image_url.default_url).to eq(ActionController::Base.helpers.asset_path("placeholder.png"))
      end
    end
  end
end
