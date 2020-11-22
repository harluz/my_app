# frozen_string_literal: true

module SessionsHelper
  # 渡されたユーザーの情報をブラウザのcookieに保存する
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログインしている状態であれば、sessionのuser_idを保有している。それが、@current_userに格納されているのか、なければ追加する
  def current_user
    if session[:user_id]
      # ログインとログアウトで使用することからインスタンス変数としている
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーのログインしていればtrue、その他ならfalse
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
