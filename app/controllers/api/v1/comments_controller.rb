class Api::V1::CommentsController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!
  load_and_authorize_resource

  def index
    respond_with @comments=Comment.all
  end

  def show
    respond_with @comment
  end

  def create
    @comment = Comment.build_comment(comment_params)
    if comment_params[:parent_id].present?
      @parent = Comment.find_by_id(comment_params[:parent_id])
    end
    @comment.save
    if @parent
      @comment.move_to_child_of(@parent)
    end
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
