class RetirementsController < ApplicationController
  def new
  end

  def create
    #ユーザレコードの削除が成功したら、セッションを削除してログアウト状態にしている
    if current_user.destroy
      reset_session
      redirect_to root_path, notice: "退会完了しました"
    end
  end
end
