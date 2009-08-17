class Message < ActiveRecord::Base
  has_many   :comments, :as => :commentable
  has_many   :attachments, :as => :attachable, :class_name => '::Attachment'
  
  belongs_to :tournament
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_and_belongs_to_many :subscribers, :class_name => "User",
    :join_table => 'messages_subscribers', :association_foreign_key => 'subscriber_id'
  
  validates_presence_of :subject, :body
  
  accepts_nested_attributes_for :attachments
end
