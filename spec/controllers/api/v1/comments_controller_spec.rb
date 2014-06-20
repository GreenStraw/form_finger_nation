require 'spec_helper'

describe Api::V1::CommentsController do
  render_views

  before(:each) do
    create_new_tenant
    login(:user)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  let(:party) { Fabricate(:party) }
  let(:venue) { Fabricate(:venue) }
  let(:comment) { Fabricate(:party_comment, commenter: @current_user) }

  describe "GET index" do
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :get, :index
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end

    context 'user authenticated' do
      before {
        xhr :get, :index
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe "GET show" do
    context 'user not authenticated' do
      before {
        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :get, :show, :id => comment.id
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end

    context 'user authenticated' do
      before {
        xhr :get, :show, :id => comment.id
      }

      it 'returns http 200' do
        response.response_code.should == 200
      end
    end
  end

  describe "POST create" do
    context 'user not authenticated' do
      before {
        comment.commentable_type = 'Party'
        comment.commentable_id = party.id
        comment.commenter_type = "User"
        comment.commenter_id = @current_user.id

        request.headers['auth-token'] = 'fake_authentication_token'
        xhr :post, :create, :comment => comment.attributes.except('id')
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end
    context 'user is authenticated' do
      context 'commenter is the current_user' do
        before {
          comment.commentable_type = 'Party'
          comment.commentable_id = party.id
          comment.commenter_type = "User"
          comment.commenter_id = @current_user.id
          xhr :post, :create, :comment => comment.attributes.except('id')
        }

        it 'returns http 201' do
          response.response_code.should == 201
        end
      end
      context 'commenter is not a user' do
        context 'current user is not able to comment as commenter' do
          before {
            comment.commentable_type = 'Party'
            comment.commentable_id = party.id
            comment.commenter_type = "Venue"
            comment.commenter_id = venue.id
            xhr :post, :create, :comment => comment.attributes.except('id')
          }

          it 'returns http 403' do
            response.response_code.should == 403
          end
        end
        context 'current user can comment as commenter' do
          before {
            comment.commentable_type = 'Party'
            comment.commentable_id = party.id
            comment.commenter_type = "Venue"
            comment.commenter_id = venue.id
            @current_user.add_role(:manager, venue)
            xhr :post, :create, :comment => comment.attributes.except('id')
          }

          it 'returns http 201' do
            response.response_code.should == 201
          end
        end
      end
    end
  end

  describe "PUT update" do
    context 'user not authenticated' do
      before {
        comment.commentable_type = 'Party'
        comment.commentable_id = party.id
        comment.commenter_type = "User"
        comment.commenter_id = @current_user.id

        request.headers['auth-token'] = 'fake_authentication_token'
        Comment.should_not_receive(:find)
        xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
      }

      it 'returns http 401' do
        response.response_code.should == 401
      end
    end

    context 'user is authenticated' do
      context 'commenter is the current_user' do
        before {
          comment.commentable_type = 'Party'
          comment.commentable_id = party.id
          comment.commenter_type = "User"
          comment.commenter_id = @current_user.id
          Comment.should_receive(:find).with(comment.id.to_s).and_return(comment)
          xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
        }

        it 'returns http 204' do
          response.response_code.should == 204
        end
      end

      context 'commenter is not a user' do
        context 'current user is not able to comment as commenter' do
          before {
            comment.commentable_type = 'Party'
            comment.commentable_id = party.id
            comment.commenter_type = "Venue"
            comment.commenter_id = venue.id
            @current_user.roles.clear
            Comment.should_receive(:find).with(comment.id.to_s).and_return(comment)
          }

          it 'returns error' do
            expect{
              xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
            }.to raise_error(CanCan::AccessDenied)
          end
        end

        context 'current user can comment as commenter' do
          before {
            comment.commentable_type = 'Party'
            comment.commentable_id = party.id
            comment.commenter_type = "Venue"
            comment.commenter_id = venue.id
            @current_user.add_role(:manager, venue)
            Comment.should_receive(:find).with(comment.id.to_s).and_return(comment)
            xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
          }

          it 'returns http 204' do
            response.response_code.should == 204
          end
        end
      end
    end
  end
end
