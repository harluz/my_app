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
    @users = User.page(params[:page]).per(PER)
  end

  def show
    @user = User.find(params[:id])
    # @user ? (redirect_to @user) : (redirect_to request.referer)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Theme Words'
      redirect_to @user
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
      redirect_to users_url
    else
      @user.destroy
      flash[:success] = 'User deleted'
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :password, :password_confirmation)
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    # ログインしていないのなら
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
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
