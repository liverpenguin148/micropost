class User < ApplicationRecord
  #バリデーション
  #Userインスタンスを保存する前に行う
  #文字をすべて小文字に変換
  before_save {self.email.downcase!}
  validates :name, presence:true,length:{maximum: 50}
  validates :email,presence:true,length:{maximum: 255},
                   #正規表現
                   format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
                   #重複を許さない
                   uniqueness: { case_sensitive: false }
  
  #パスワード付きのモデルを作成するため
  #モデル作成時に、password_digestが必要
  #Gemfileには、bcrypt Gemも必要
  has_secure_password
  
  has_many :microposts
end
