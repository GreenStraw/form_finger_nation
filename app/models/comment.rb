class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :commenter, :presence => true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, polymorphic: true

  # NOTE: Comments belong to a commenter
  belongs_to :commenter, polymorphic: true

  def self.build_comment(params)
    commentable = params[:commentable_type].constantize.find(params[:commentable_id])
    commenter = params[:commenter_type].constantize.find(params[:commenter_id])
    if commentable.present? && commenter.present? && params[:body].present?
      @comment = Comment.build_from(commentable, commenter, params[:body])
    end
    @comment || nil
  end

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(commentable, commenter, comment)
    new \
      :commentable  => commentable,
      :commenter    => commenter,
      :body         => comment
  end

  def self.find_comments_by_commenter(commenter)
    Comment.where(:commenter_id => commenter.id, :commenter_type => commenter.class).order('created_at DESC')
  end

  def self.find_comments_for_commentable(commentable)
    Comment.where(:commentable_type => commentable.class, :commentable_id => commentable.id).order('created_at DESC')
  end

  def self.find_commentable(commentable_type, commentable_id)
    commentable_type.constantize.find_by_id(commentable_id)
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end
end
