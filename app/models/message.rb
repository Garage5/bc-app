class Message < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  validates_presence_of :subject, :body
  # has_many :comments
end
