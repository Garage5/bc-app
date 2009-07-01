class Message < ActiveRecord::Base
  has_many   :comments, :as => :commentable
  has_many   :attachments, :as => :attachable, :class_name => '::Attachment'
  
  belongs_to :tournament
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  validates_presence_of :subject, :body
  
  accepts_nested_attributes_for :attachments
end
