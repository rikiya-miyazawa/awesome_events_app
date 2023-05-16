class TicketsController < ApplicationController
  def new
    #基本的にログインしていないとイベント参加はできないが、
    #urlベタ打ちでnew画面に行こうとしてくるユーザ用の対策
    raise ActionController::RoutingError, "ログイン状態でTicketsController#newにアクセス"
  end

  def create
    event = Event.find(params[:event_id])
    @ticket = current_user.tickets.build do |t|
      t.event = event  #@ticket変数に、リクエストから取得したイベントのIDに基づいて、Event モデルから取得されたイベントオブジェクトを代入している
      t.comment = params[:ticket][:comment]  #@ticket変数に、リクエストパラメータから送信されたチケットコメントを取得して代入している
    end
    if @ticket.save
      redirect_to event, notice: "このイベントに参加表明しました"
    end
  end
end
