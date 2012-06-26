class Micropost
  include Mongoid::Document
  include Mongoid::Timestamps::Created # Track the timestamps but only the created_at field
  field :content
  field :user_id, :type => Integer
  
  attr_accessible :content
  
  belongs_to :user
  
  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true
  
  default_scope desc(:created_at)
  
  def self.from_users_followed_by(user)
    any_in(:user_id => user.following_relations.map(&:followed_id) << user.id)
    # any_in(:user_id => user.following.push(user).map(&:to_param)) #- Shorter syntax, but less efficient
  end
end