# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :correct_user, only: %i[eidt update　destroy]
  before_action :admin_user, only: %i[destroy]

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      # 保存されたときの処理を記載する
      flash[:success] = 'Order created!'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    # correct_userで@orderが定義されているため、省略できる
  end

  def update
    @order.update(order_params)
    flash[:success] = 'You order has been fixed'
    redirect_to user_path(current_user)
  end

  def destroy
    # 注文者及び管理者自身が削除できるようにする
    @order.destroy
    flash[:success] = 'Order deleted'
    redirect_back(fallback_location: root_url)
  end

  private

  def order_params
    params.require(:order).permit(:english, :japanese, :comment)
  end

  def correct_user
    @order = current_user.orders.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_url
      flash[:info] = 'You connnot edit this order'
    end
  end

  def addmin_user
    rediderect_to root_url unless current_user.admin?
    @order = Order.find_by(id: params[:id])
    redirect_to root_url if @order.nil?
  end
end
