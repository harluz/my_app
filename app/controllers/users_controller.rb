# frozen_string_literal: true

require 'pry'

class UsersController < ApplicationController
  protect_from_forgery with: :exception, only: :create
  protect_from_forgery unless: -> { request.format.json? }

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
      log_in @user
      flash[:success] = 'Welcome to the Theme Words'
      # redirect_to @user
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :password, :password_confirmation)
  end
end
