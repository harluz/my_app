# frozen_string_literal: true

class SessionsController < ApplicationController
  protect_from_forgery with: :exception, only: :create
  protect_from_forgery unless: -> { request.format.json? }

  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # user_url(user)
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email / password combination'
      render 'new'
    end
  end

  def destroy
    # 　ログインしているときのみログアウトできる
    log_out if logged_in?
    redirect_to root_url
    # flashを追加したい
  end
end
