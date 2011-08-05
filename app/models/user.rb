class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name, :type => String
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates_uniqueness_of :email, :case_sensitive => false
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
end
