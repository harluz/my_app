# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the Theme Words'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :password,
                                 :password_confirmation)
  end
end
