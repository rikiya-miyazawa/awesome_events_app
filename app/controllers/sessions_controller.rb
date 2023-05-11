class SessionsController < ApplicationController

  def create
    #request.env["omniauth.auth"]というHashに似たOmniAuth::AuthHashクラスのオブジェクトを利用
    #GitHubから渡されたユーザ情報や、OAuthのアクセストークンなどが格納されている
    user = User.find_or_create_from_auth_hash!(request.env["omniauth.auth"])
    #User.find_or_create_from_auth_hash!が返すUserオブジェクトのIDをセッションに格納することでログイン扱いとする
    session[:user_id] = user.id
    redirect_to root_path, notice: "ログインしました"
  end

  def destroy
    #reset_sessionメソッドでセッションに入っていた値が全て削除される
    reset_session
    redirect_to root_path, notice: "ログアウトしました"
  end
end
