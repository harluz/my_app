# frozen_string_literal: true

include ApplicationHelper

module TestHelper
  def is_logged_in?
    !session[:user_id].nil?
  end
end
