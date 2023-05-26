FactoryBot.define do
  # 第一引数 :userがテストケースから呼び出す時の名称  # 第一引数がモデルクラス名と同じ時にはクラス名の指定が省略可能
  # aliases: [:owner]は別名:ownerでもテストケースから呼び出せるようにする設定
  factory :user, aliases: [:owner] do  
    # attribute名{"設定する値"}で各attributeへ値を設定していく
    # attributeとはFactoryBotによって作成されるオブジェクトの属性やプロパティを指す
    # "github"や:nameや:image_urlがattribute
    # FactoryBotでは、factoryメソッドのブロック内で各attributeに値を設定する
    # { provider: "github" } というハッシュ型のデータになる
    provider { "github" }  # providerというattributeに対して"github"という値を設定している
    # sequenceメソッドは連番を設定するメソッド
    # ユニーク制約を回避したり、固定値ではない値を使ったデータの生成ができる
    sequence(:uid) { |i| "uid#{i}" }  # "uid1", "uid2" ...のように連番になる
    sequence(:name) { |i| "name#{i}" }
    sequence(:image_url) { |i| "http://example.com/image#{i}.jpg" }
  end
end
