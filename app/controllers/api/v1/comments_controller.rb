class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user_from_token!
  load_and_authorize_resource

  def index
    respond_with @comments
  end

  def show
    respond_with @comment
  end

  def create
    @comment.save
    respond_with @comment, :location=>api_v1_comments_path
  end

  def update
    @comment.update(comment_params)
    respond_with @comment, :location=>api_v1_comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :commenter_id, :commenter_type, :user_id, :body)
  end

end
