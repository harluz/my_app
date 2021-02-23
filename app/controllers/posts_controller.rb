# frozen_string_literal: true

class PostsController < ApplicationController
  protect_from_forgery with: :exception, only: %i[destroy]

  before_action :logged_in_user, only: %i[new create destroy]
  before_action :admin_user, only: %i[destroy]
  before_action :correct_user, only: %i[edit update]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post created!'
      redirect_to root_url
    else
      # 投稿に失敗した場合の処理
      @image_items = Post.all.order(created_at: 'DESC').page(params[:page]).per(PER)
      render 'static_pages/home'
    end
  end

  def edit
    # correct_userで@postが定義されているため省略
  end

  def update
    if @post.update(post_params)
      flash[:success] = 'Your post has been fixed.'
      redirect_to user_path(current_user)
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post deleted'
    redirect_back(fallback_location: root_url)
    # redirect_to request.referrer || root_url
  end

  private

  def post_params
    params.require(:post).permit(:english, :japanese, :image, :comment)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      redirect_to root_url
      flash[:info] = 'You connot edit this post'
    end
  end

  # 管理者でない場合は、root_urlにリダイレクトする
  def admin_user
    redirect_to(root_url) unless current_user.admin?
    @post = Post.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
