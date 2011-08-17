class Relationship
  include Mongoid::Document
  include Mongoid::Timestamps::Created # Track the timestamps but only the created_at field
  field :follower_id, :type => Integer
  field :followed_id, :type => Integer
  # index on both columns and also includes a composite index that enforces uniqueness of pairs
  index([[:follower_id, Mongo::ASCENDING], [:followed_id, Mongo::ASCENDING]], :unique => true)
  
  attr_accessible :followed_id
  
  belongs_to :follower, :class_name => "User", :inverse_of => :following_relations
  belongs_to :followed, :class_name => "User", :inverse_of => :followers_relations
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
