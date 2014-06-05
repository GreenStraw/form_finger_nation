require 'spec_helper'

describe Api::V1::CommentsController do
  let(:user) { Fabricate(:user) }
  let(:party) { Fabricate(:party) }
  let(:venue) { Fabricate(:venue) }
  let(:comment) { Fabricate(:party_comment, commenter: user) }
  before(:each) do
    Address.any_instance.stub(:geocode).and_return([1,1])
    party
    venue
    comment
    user
    user.confirm!
  end

  describe "POST create" do
    context 'user not authenticated' do
      before {
        comment.commentable_type = 'Party'
        comment.commentable_id = party.id
        comment.commenter_type = "User"
        comment.commenter_id = user.id
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        subject.stub(:current_user).and_return(user)
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
          comment.commenter_id = user.id
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          subject.stub(:current_user).and_return(user)
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
            user.ensure_authentication_token!
            request.headers['auth-token'] = user.authentication_token
            request.headers['auth-email'] = user.email
            subject.stub(:current_user).and_return(user)
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
            user.ensure_authentication_token!
            user.add_role(:manager, venue)
            request.headers['auth-token'] = user.authentication_token
            request.headers['auth-email'] = user.email
            subject.stub(:current_user).and_return(user)
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
        comment.commenter_id = user.id
        user.ensure_authentication_token!
        request.headers['auth-token'] = 'fake_authentication_token'
        request.headers['auth-email'] = user.email
        Comment.should_not_receive(:find)
        subject.stub(:current_user).and_return(user)
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
          comment.commenter_id = user.id
          user.ensure_authentication_token!
          request.headers['auth-token'] = user.authentication_token
          request.headers['auth-email'] = user.email
          Comment.should_receive(:find).with(comment.id.to_s).and_return(comment)
          subject.stub(:current_user).and_return(user)
          xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
        }

        it 'returns http 200' do
          response.response_code.should == 200
        end
      end

      context 'commenter is not a user' do
        context 'current user is not able to comment as commenter' do
          before {
            comment.commentable_type = 'Party'
            comment.commentable_id = party.id
            comment.commenter_type = "Venue"
            comment.commenter_id = venue.id
            user.ensure_authentication_token!
            request.headers['auth-token'] = user.authentication_token
            request.headers['auth-email'] = user.email
            Comment.should_receive(:find).with(comment.id.to_s).and_return(comment)
            subject.stub(:current_user).and_return(user)
            xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
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
            user.ensure_authentication_token!
            user.add_role(:manager, venue)
            request.headers['auth-token'] = user.authentication_token
            request.headers['auth-email'] = user.email
            Comment.should_receive(:find).with(comment.id.to_s).and_return(comment)
            subject.stub(:current_user).and_return(user)
            xhr :put, :update, id: comment.id, :comment => {body: 'Different Body'}
          }

          it 'returns http 200' do
            response.response_code.should == 200
          end
        end
      end
    end
  end
end
