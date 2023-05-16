class Ticket < ApplicationRecord
  belongs_to :user, optional: true  #optional: true  関連先がなくてもバリデーションエラーにならないように
  belongs_to :event
  validates :comment, length: { maximum: 30 }, allow_blank: true  #allow_blank: true 空文字やnilを許可
end
