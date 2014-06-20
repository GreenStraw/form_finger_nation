require 'spec_helper'

describe Comment do
  it { should validate_presence_of :body }
  it { should validate_presence_of :commenter }

  before(:each) do
    tenant = Fabricate(:test_tenant)
    Thread.current[:tenant_id] = tenant
    Tenant.set_current_tenant tenant
    Address.any_instance.stub(:geocode).and_return([1,1])
    @user = Fabricate(:user)
    @party = Fabricate(:party)
    @comment = Fabricate(:comment, commenter_id: @user.id, commenter_type: 'User',
                          commentable_id: @party.id, commentable_type: 'Party')
  end

  describe "self.find_comments_by_commenter(commenter)" do
    it "should return comments created by the specified commenter" do
      Comment.find_comments_by_commenter(@user).should == [@comment]
    end
    it "should not return comments created by another commenter" do
      another_user = Fabricate(:user)
      another_comment = Fabricate(:comment, commenter_id: another_user.id, commenter_type: 'User',
                          commentable_id: @party.id, commentable_type: 'Party')
      Comment.find_comments_by_commenter(@user).should_not include(another_comment)
    end
  end

  describe "self.find_comments_for_commentable(commentable)" do
    it "should return comments for the specified commentable" do
      Comment.find_comments_for_commentable(@party).should == [@comment]
    end
    it "should not return comments for another commentable" do
      another_party = Fabricate(:party)
      another_comment = Fabricate(:comment, commenter_id: @user.id, commenter_type: 'User',
                          commentable_id: another_party.id, commentable_type: 'Party')
      Comment.find_comments_for_commentable(@party).should_not include(another_comment)
    end
  end

  describe "self.find_commentable(commentable_type, commentable_id)" do
    it "should return the commentable object if type and id match" do
      Comment.find_commentable('Party', @party.id).should == @party
    end
    it "should return nil if no match" do
      Comment.find_commentable('Party', 'fake_id').should == nil
    end
  end
end
