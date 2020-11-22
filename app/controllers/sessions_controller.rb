# frozen_string_literal: true

class SessionsController < ApplicationController
  protect_from_forgery with: :exception, only: :create
  protect_from_forgery unless: -> { request.format.json? }

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # user && user.authenticate(params[:session][:password]) (rubocopより修正)
    if user&.authenticate(params[:session][:password])
      log_in user
      # user_url(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email / password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
    # flashを追加したい
  end
end
