# frozen_string_literal: true

class StaticPagesController < ApplicationController
  PER = 10

  def home
    if logged_in?
      # @post = current_user.posts.build if logged_in?
      @image_items = Post.all.order(created_at: 'DESC').page(params[:page]).per(PER)
    end
  end

  # def log_in; end

  # def log_out; end

  def about; end

  # def profile; end

  # def my_list; end

  # def suggest; end

  # def seek; end
end
