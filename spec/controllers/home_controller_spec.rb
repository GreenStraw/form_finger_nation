require 'spec_helper'

describe HomeController do
  
  render_views
  
  context 'when anonymous' do
    describe 'GET index' do
      it 'should return http status 200' do
        get :index
        response.status.should == 200
      end
      it 'should render the index view' do
        get :index
        expect(response).to render_template('index')
      end
      it 'should relect the generic tenant' do
        get :index
        response.body.should have_css('div.jumbotron')
        response.body.should have_content('Hello, BaseAppers')
      end
    end
  end
  
  context 'when authenticated' do
    before do
      create_new_tenant
      login(:admin)
    end
    describe 'GET index' do
      it 'should return http status 200' do
        get :index
        response.status.should == 200
      end
      it 'should render the welcome view' do
        get :index
        expect(response).to render_template('welcome')
      end
      it 'should show the user controls' do
        get :index
        response.body.should have_content('My Account')
      end
    end
  end

end
