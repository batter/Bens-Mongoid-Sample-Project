class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created # Track the timestamps but only the created_at field
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  field :name
  field :admin, :type => Boolean
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  has_many :microposts, :dependent => :destroy # destroy associated microposts before_destroy
  has_many :following_relations, :class_name => "Relationship", :foreign_key => :follower_id, :inverse_of => :follower, :dependent => :destroy
  has_many :followers_relations, :class_name => "Relationship", :foreign_key => :followed_id, :inverse_of => :followed, :dependent => :destroy
  
  validates :name, :presence => true, :length   => { :maximum => 60 }
  validates_uniqueness_of :email, :case_sensitive => false
  
  scope :admin, where(:admin => true)
  
  paginates_per 30
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def toggle_admin!
    self.admin = !admin
    self.save!
  end
  
  # Methods for following/follower relationships
  def following
    #User.any_in(:_id => following_relations.collect {|rel| rel.followed_id})
    User.any_in(:_id => following_relations.map(&:followed_id))
  end
  
  def followers
    #User.any_in(:_id => followers_relations.collect {|rel| rel.follower_id})
    User.any_in(:_id => followers_relations.map(&:follower_id))
  end
  
  def following?(followed)
    following.include?(followed)
  end

  def follow!(followed)
    following_relations.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    following_relations.where(:followed_id => followed.id).first.destroy
  end
end