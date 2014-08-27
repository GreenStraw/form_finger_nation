require 'spec_helper'

describe SportImageUploader do
  before (:each) do
    @sport = Fabricate(:sport)
  end
  describe 'store_dir' do
    context "sport store_dir" do
      it 'should be image' do
        expect(@sport.image_url.store_dir).to eq('images')
      end
    end
  end

  describe 'default_url' do
    context 'sport default_url' do
      it 'should return ActionController::Base.helpers.asset_path("placeholder.png")' do
        expect(@sport.image_url.default_url).to eq(ActionController::Base.helpers.asset_path("placeholder.png"))
      end
    end
  end
end
