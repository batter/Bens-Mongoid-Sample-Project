class Micropost
  include Mongoid::Document
  include Mongoid::Timestamps::Created # Track the timestamps but only the created_at field
  field :content
  field :user_id, :type => Integer
  
  attr_accessible :content
  
  belongs_to :user
  
  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true
  
  default_scope :order => {:created_at, :desc}
end