# frozen_string_literal: true

class SessionsController < ApplicationController
  protect_from_forgery with: :exception, only: :create
  protect_from_forgery unless: -> { request.format.json? }

  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      # userが有効である時はログインする
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = 'Account not activated.'
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
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
