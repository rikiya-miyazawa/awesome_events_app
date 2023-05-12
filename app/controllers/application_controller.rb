class ApplicationController < ActionController::Base
  #未ログインで操作させないようにbefore_actionでapplication_controller.rbに定義
  #未ログインでも操作させたい処理(ログイン処理など)はskip_before_actionでスキップする
  before_action :authenticate
  #今後コントローラとビューの両方から利用する機会があるのでヘルパーメソッドでメソッド名を宣言しておく
  helper_method :logged_in?, :current_user

  private

  def logged_in?
    #not演算子(!)をふたつ重ねることで
    #session[:user_id]がfalseまたはnilの時はfalseを、それ以外の値の時はtrueへ変換する
    !!session[:user_id]
  end

  def current_user
    #ログインしているユーザ自身でなければreturnで処理を抜ける
    return unless session[:user_id]
    #@current_userにログインしているユーザの情報を代入する
    @current_user ||= User.find(session[:user_id])
  end

  def authenticate
    #ログインしていたらreturnで処理を抜ける
    return if logged_in?
    #ログインしていなければトップページにリダイレクトさせる
    redirect_to root_path, alert: "ログインしてください"
  end
end
