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
    @comment_hash = params[:comment]
    if params[:comment][:parent_id].present?
      @parent = Comment.find(params[:comment][:parent_id])
    end
    @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    @commenter = @comment_hash[:commenter_type].constantize.find(@comment_hash[:commenter_id])
    @comment = Comment.build_from(@obj, @commenter, @comment_hash[:body])
    if @commenter == current_user || current_user.has_role?(:manager, @commenter)
      if @comment.save
        if @parent
          @comment.move_to_child_of(@parent)
        end
        return render json: @comment, status: 201
      else
        return render json: @comment, status: 422
      end
    end
    return render json: {}, status: 403
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
