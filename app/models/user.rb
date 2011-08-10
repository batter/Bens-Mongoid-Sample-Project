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
  
  validates :name, :presence => true, :length   => { :maximum => 50 }
  validates_uniqueness_of :email, :case_sensitive => false
  
  paginates_per 30
  
  def feed
    Micropost.where(:user_id => id)
  end
  
  def toggle_admin!
    self.admin = !admin
    self.save!
  end
end