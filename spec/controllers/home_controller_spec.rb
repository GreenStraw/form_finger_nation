require 'spec_helper'

describe HomeController do

  render_views

  before(:each) do
    create_new_tenant
    login(:admin)
  end

  describe 'GET about' do
    it 'should return http status 200' do
      get :about
      response.status.should == 200
    end
    it 'should render the welcome view' do
      get :about
      expect(response).to render_template('about')
    end
  end

  describe 'GET contact' do
    it 'should return http status 200' do
      get :contact
      response.status.should == 200
    end
    it 'should render the contact view' do
      get :contact
      expect(response).to render_template('contact')
    end
  end

  describe 'GET faq' do
    it 'should return http status 200' do
      get :faq
      response.status.should == 200
    end
    it 'should render the faq view' do
      get :faq
      expect(response).to render_template('faq')
    end
  end

  describe 'GET home' do
    it 'should return http status 200' do
      get :home
      response.status.should == 200
    end
    it 'should render the home view' do
      get :home
      expect(response).to render_template('home')
    end
  end

  describe 'GET how' do
    it 'should return http status 200' do
      get :how
      response.status.should == 200
    end
    it 'should render the how view' do
      get :how
      expect(response).to render_template('how')
    end
  end

  describe 'GET jobs' do
    it 'should return http status 200' do
      get :jobs
      response.status.should == 200
    end
    it 'should render the jobs view' do
      get :jobs
      expect(response).to render_template('jobs')
    end
  end

  describe 'GET privacy' do
    it 'should return http status 200' do
      get :privacy
      response.status.should == 200
    end
    it 'should render the privacy view' do
      get :privacy
      expect(response).to render_template('privacy')
    end
  end

  describe 'GET terms' do
    it 'should return http status 200' do
      get :terms
      response.status.should == 200
    end
    it 'should render the terms view' do
      get :terms
      expect(response).to render_template('terms')
    end
  end

end
