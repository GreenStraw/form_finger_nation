require 'spec_helper'

describe Api::V1::TeamsController do
  render_views
  
  let(:team) { Fabricate(:team) }
  let(:user) { Fabricate(:user) }
  before do
    create_new_tenant
    @team = Fabricate.attributes_for(:team)
    team
    user
    user.confirm!
  end

  describe 'GET index' do
    context 'index' do
      before do
        get :index
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'GET show' do
    context 'show' do
      before do
        get :show, id: team.id
      end

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'POST create' do
    context 'current user not admin' do
      before {
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :team => @team
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'user not authenticated' do
      before {
       
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :team => @team
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'team failed to save' do
      before {
        user.add_role :admin
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        sp = Sport.create
        sp.stub(:id).and_return('1')
        t = Team.new(sport: sp)
        Team.should_receive(:new).with(@team).and_return(t)
        t.should_receive(:save).and_return(false)
        xhr :post, :create, :team => {"name"=>"test_team", "image_url"=>nil, "sport_id"=>"1"}
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        user.add_role :admin
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :create, :team => @team
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'PUT update' do
    context 'current user not admin or team admin' do
      before {
        team = Fabricate(:team)
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: team.id, team: {name: 'another_name'}
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'user not authenticated' do
      before {
       
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :update, id: team.id, team: {name: 'another_name'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'team failed to save' do
      before {
        team = Fabricate(:team)
        user.add_role :admin
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Team.should_receive(:find).with(team.id.to_s).and_return(team)
        team.should_receive(:update!).and_return(false)
        xhr :put, :update, id: team.id, team: {name: 'another_name'}
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        team = Fabricate(:team)
        user.add_role :admin
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: team.id, team: {name: 'another_name'}
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end

    context 'everything is good - user has team_admin role' do
      before {
        team = Fabricate(:team)
        user.add_role :team_admin, team
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :put, :update, id: team.id, team: {name: 'another_name'}
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe 'DELETE destroy' do
    context 'current user not admin' do
      before {
        team = Fabricate(:team)
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: team.id
      }

      it 'returns http 403' do
        response.response_code.should == 403
      end
    end
    context 'user not authenticated' do
      before {
       
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :destroy, id: team.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'team failed to save' do
      before {
        team = Fabricate(:team)
        user.add_role :admin
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        Team.should_receive(:find).with(team.id.to_s).and_return(team)
        team.should_receive(:destroy).and_return(false)
        xhr :delete, :destroy, id: team.id
      }

      it 'returns http 422' do
        response.response_code.should == 422
      end
    end
    context 'everything is good' do
      before {
        team = Fabricate(:team)
        user.add_role :admin
       
        request.headers['auth-token'] = user.authentication_token
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :delete, :destroy, id: team.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe "PUT add_host" do
    context 'user not authenticated' do
      before {
       
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :add_host, id: team.id, user_id: user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user authenticated' do
      context 'current user does not have team admin role for team' do
        before {
         
          user.roles.clear
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :post, :add_host, id: team.id, user_id: user.id
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current user does have team admin role for team' do
        before {
         
          user.add_role(:team_admin, team)
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :post, :add_host, id: team.id, user_id: user.id
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
      context 'team already includes user as a host' do
        it 'should not call <<' do
         
          user.add_role(:team_admin, team)
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          team.endorsed_hosts = [user]
          team.should_not_receive(:<<)
          xhr :post, :add_host, id: team.id, user_id: user.id
        end
      end
      context 'team does not include user as a host' do
        it 'should add user to endorsed_hosts' do
         
          user.add_role(:team_admin, team)
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          team.endorsed_hosts.should_not include(user)
          xhr :post, :add_host, id: team.id, user_id: user.id
          assigns(:team).endorsed_hosts.should include(user)
        end
      end
    end
  end

  describe "PUT remove_host" do
    context 'user not authenticated' do
      before {
       
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
        xhr :post, :remove_host, id: team.id, user_id: user.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user authenticated' do
      context 'current user does not have team admin role for team' do
        before {
         
          user.roles.clear
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :post, :remove_host, id: team.id, user_id: user.id
        }

        it 'returns http 403' do
          response.response_code.should == 403
        end
      end
      context 'current user does have team admin role for team' do
        before {
         
          user.add_role(:team_admin, team)
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          xhr :post, :remove_host, id: team.id, user_id: user.id
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end
      context 'team already includes user as a host' do
        it 'should remove the user' do
         
          user.add_role(:team_admin, team)
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          team.endorsed_hosts = [user]
          team.endorsed_hosts.should include(user)
          xhr :post, :remove_host, id: team.id, user_id: user.id
          assigns(:team).endorsed_hosts.should_not include(user)
        end
      end
      context 'team does not include user as a host' do
        it 'should not call delete' do
         
          user.add_role(:team_admin, team)
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
          team.endorsed_hosts.should_not_receive(:delete)
          xhr :post, :remove_host, id: team.id, user_id: user.id
        end
      end
    end
  end
end
