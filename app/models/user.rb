class User < ApplicationRecord
  #関連元のユーザが作成したイベントという意味で「create_events」という命名
  #モデル名以外の名前を関連名に使用したのでclass_nameオプションでクラス名を指定
  #外部キーもデフォルトの「user_id」ではないのでforeign_keyオプションで外部キー(owner_id)を指定
  has_many :created_events, class_name: "Event", foreign_key: "owner_id"
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
end
