class User < ApplicationRecord
  before_destroy :check_all_events_finished  #Userモデルの削除時に実行されるコールバックを追加
  #関連元のユーザが作成したイベントという意味で「create_events」という命名
  #モデル名以外の名前を関連名に使用したのでclass_nameオプションでクラス名を指定
  #外部キーもデフォルトの「user_id」ではないのでforeign_keyオプションで外部キー(owner_id)を指定
  has_many :created_events, class_name: "Event", foreign_key: "owner_id", dependent: :nullify
  has_many :tickets, dependent: :nullify  #dependent: :nullifyオプションで削除した時に関連するレコードの外部キーをnullにできる
  has_many :participating_events, through: :tickets, source: :event
  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]
    
    #引数で渡したproviderとuidを持つレコードが存在していれば、そのオブジェクトを返す
    #存在しなければprovider, uid, name, image_urlを設定してレコードを作成し、そのオブジェクトを返す
    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = nickname
      user.image_url = image_url
    end
  end

  private

  def check_all_events_finished
    now = Time.zone.now
    #現在の時間より終了時間が後のイベント、つまり「未終了」のイベントがあるか調べる
    #もしも未終了のイベントが存在する場合はerrorsオブジェクトにエラーメッセージを追加する
    if created_events.where(":now < end_at", now: now).exists?
      #erroes[:base]はActiveRecordモデルのエラーオブジェクトに対してエラーメッセージを追加するための特殊なキー
      #errors[:base] を使用すると、モデル全体に関連するエラーメッセージを追加することができる
      errors[:base] << "公開中の未終了イベントが存在します。"
    end

    #ユーザが参加しているイベントを調べる
    if participating_events.where(":now < end_at", now: now).exists?
      errors[:base] << "未終了の参加イベントが存在します。"
    end

    throw(:abort) unless errors.empty?
  end
end
