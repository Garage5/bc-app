class Message < ActiveRecord::Base
  has_many   :comments, :as => :commentable
  
  belongs_to :tournament
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  validates_presence_of :subject, :body
end
