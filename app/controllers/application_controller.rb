# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    # ログインしていないのなら
    if logged_in?
      # return
      nil
    else
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
