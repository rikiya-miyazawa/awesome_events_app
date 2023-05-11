Rails.application.routes.draw do
  resources :events
  root 'welcome#index'
  #OmniAuthによる認証が成功した場合、デフォルトで/auth/:provider/callbackがコールバック用のURLとして利用される
  #それをログイン用のアクションと紐付ける
  get "/auth/:provider/callback" => "sessions#create"
  delete "/logout" => "sessions#destroy"
end
