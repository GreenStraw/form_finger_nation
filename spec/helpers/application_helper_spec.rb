require 'spec_helper'

describe ApplicationHelper do

  describe 'display site_name' do
    it {
      assign(:org_name, 'org')
      helper.site_name.should eql('org')
    }
  end

  describe 'site_url' do
    describe 'when environment is development and test then site url' do
      it { helper.site_url.should eql('http://localhost:3000')  }
    end
    describe 'when environment is production then site url' do
      it { 
        Rails.stub(env: ActiveSupport::StringInquirer.new('production'))
        if Rails.env.test?
          helper.site_url.should eql('http://localhost:3000')
        else
          helper.site_url.should eql('http://www.BaseApp.com/')  
        end
      }
    end
  end

  describe 'meta author' do
    it { helper.meta_author.should eql('Website Author')  }
  end

  describe 'meta descripiton' do
    it { helper.meta_description.should eql('Add your website descripiton here')  }
  end

  describe 'meta keywords' do
    it { helper.meta_keywords.should eql('Add some keywords here')  }
  end
  
  describe 'full_title' do
    describe 'when page title present in full title ' do
      it { helper.full_title('welcome').should eql('welcome | BaseApp')  }
    end
    describe 'when page title not present in full title' do
      it { helper.full_title('').should eql('BaseApp')  }
    end
  end
  
  describe 'flash_type_to_alert' do
    describe 'when flash type is notice' do
      it{
        name = 'notice'
        flash[:notice]= 'flash #{name.to_s} message'
        helper.flash_type_to_alert(:notice).should eql(:success)
      }
    end
    describe 'when flash type is info' do
      it{
        name = 'info'
        flash[:info]= 'flash #{name.to_s} message'
        helper.flash_type_to_alert(:info).should eql(:info)
      }
    end
    describe 'when flash type is alert' do
      it{
        name = 'alert'
        flash[:alert]= 'flash #{name.to_s} message'
        helper.flash_type_to_alert(:alert).should eql(:warning)
      }
    end
    describe 'when flash type is error' do
      it{
        name = 'error'
        flash[:error]= 'flash #{name.to_s} message'
        helper.flash_type_to_alert(:error).should eql(:danger)
      }
    end
    describe 'when flash type is not vallid' do
      it{
        helper.flash_type_to_alert(:success).should eql(:success)
      }
    end
  end

  describe 'devise_mapping' do
    it{
      helper.devise_mapping.class.should eql(Devise::Mapping)
    }
  end

  describe 'resource_name' do
    it{
      helper.resource_name.should eql(:user)
    }
  end

  describe 'resource_class' do
    it{
      helper.resource_class.should eql(User)
    }
  end
  
end
