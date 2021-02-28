# frozen_string_literal: true

require 'pry-byebug'

class UsersController < ApplicationController
  protect_from_forgery with: :exception, only: %i[create update destroy]
  protect_from_forgery unless: -> { request.format.json? }

  # editとupdateアクションの前にログインしているか確認する
  before_action :logged_in_user, only: %i[index edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  # 一度に表示する数
  PER = 10

  def index
    @users = User.where(activated: true).page(params[:page]).per(PER)
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      redirect_to(root_url) && return unless @user.activated?

      # @user ? (redirect_to @user) : (redirect_to request.referer)
      @posts = @user.posts.page(params[:page]).per(PER)
      @orders = @user.orders.page(params[:page]).per(PER)
      # @responses = @user.responses.page(params[:page]).per(PER)
    else
      # ログインしていないユーザーの挙動が微妙
      redirect_to users_url
      flash[:danger] = 'That user does not exist'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
      # log_in @user
      # flash[:success] = 'Welcome to the Theme Words'
      # redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # correct_userで@userが定義されているため記述不要
    # @user = User.find(params[:id])
  end

  def update
    # correct_userで@userが定義されているため記述不要
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    # adminのユーザーを削除できない仕様に変更
    if @user.admin?
      flash[:danger] = 'This user cannot be deleted.'
    else
      @user.destroy
      flash[:success] = 'User deleted'
    end
    redirect_to users_url
  end

  def ajax_my_posts
    # 対応するjsファイルにインスタンス変数を渡す
    @posts = @user.posts.page(params[:page]).per(PER)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :password, :password_confirmation)
  end

  # 正しいユーザーかどうか確認
  def correct_user
    # @userを定義している
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者でない場合は、root_urlにリダイレクトする
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
