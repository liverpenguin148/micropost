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
  has_many :favorites
  has_many :like_posts, through: :favorites, source: :micropost
  #relationshipsとの関係
  has_many :relationships
  #上記relationshipsを通じて、follow_idを参照し、followingsをみる
  has_many :followings, through: :relationships, source: :follow
  
  has_many :reverse_of_relationships,class_name: 'Relationship',foreign_key: 'follow_id'
  has_many :followers,through: :reverse_of_relationships,source: :user
  
  #other_userが自分でないか、既にフォローしていないか
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
    
  #フォローしていれば、フォローを外す
  def unfollow(other_user)
    relationships = self.relationships.find_by(follow_id: other_user.id)
    relationships.destroy if relationships
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  #フォロー処理の終了
  
  #お気に入り処理
  def favorite(micropost)
      unless self.id == micropost.user_id
        self.favorites.find_or_create_by(micropost_id: micropost.id)
      end
  end
  
  def unfavorite(micropost)
    micropost = self.favorites.find_by(micropost_id: micropost.id)
    micropost.destroy if micropost
  end
  
  def favorite?(micropost)
    self.like_posts.include?(micropost)
  end
  #お気に入り処理終了
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end
