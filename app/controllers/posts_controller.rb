class PostsController < ApplicationController
  before_action :require_login

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id

    if @post.save
      redirect_to subs_url
    else
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.author_id == current_user.id && @post.update(post_params)
      redirect_to sub_url(@post.sub)
    else
      flash[:errors] = @post.errors.full_messages
      if flash[:errors].empty?
        flash[:errors] = ["incorrect user"]
      end
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to subs_url
  end

  def show
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
