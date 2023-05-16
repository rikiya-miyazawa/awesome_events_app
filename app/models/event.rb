class Event < ApplicationRecord
  has_many :tickets, dependent: :destroy
  belongs_to :owner, class_name: "User"
  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :content, length: { maximum: 2000 }, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_at_should_be_before_end_at
  
  #ログインユーザが閲覧しているイベントの作成者かどうかチェックする
  def created_by?(user)  #viewでcurrent_userの値が送られてくる
    return false unless user  #ユーザがnil(つまり未ログイン)の場合falseを返す
    owner_id == user.id  #ユーザのidとイベントのオーナーのidが一致していればtrue、一致しなければfalseを返す
  end

  private

  def start_at_should_be_before_end_at
    #start_atカラムとend_atカラムのどちらかのデータがなければ(nil)、このメソッドを抜ける
    #nilチェック
    return unless start_at && end_at

    if start_at >= end_at
      errors.add(:start_at, "は終了時間よりも前に設定してください")
    end
  end
end
