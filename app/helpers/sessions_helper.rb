# frozen_string_literal: true

module SessionsHelper
  # 渡されたユーザーの情報をブラウザのcookieに保存する
  def log_in(user)
    session[:user_id] = user.id
  end

  # signedメソッドー＞暗号化と複合化が可能なメソッド
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # ログインしている状態であれば、sessionのuser_idを保有している。それが、@current_userに格納されているのか、なければ追加する
  # cookieに保存さたユーザーIDをもとにユーザーの情報を取得するメソッド
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # userのログイン状態をtrue or false で判断したい
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトさせる
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
