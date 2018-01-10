class CommentsController < ApplicationController
  def show
    @comment = Comment.find_by(id: params[:id])
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id

    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def new
    @comment = Comment.new(post_id: params[:post_id])
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
