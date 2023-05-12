class ApplicationController < ActionController::Base
  #今後コントローラとビューの両方から利用する機会があるのでヘルパーメソッドでメソッド名を宣言しておく
  helper_method :logged_in?

  private

  def logged_in?
    #not演算子(!)をふたつ重ねることで
    #session[:user_id]がfalseまたはnilの時はfalseを、それ以外の値の時はtrueへ変換する
    !!session[:user_id]
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: "ログインしてください"
  end
end
