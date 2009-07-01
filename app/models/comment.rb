class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  has_many :attachments, :as => :attachable, :class_name => '::Attachment'
  
  validates_presence_of :body
  
  accepts_nested_attributes_for :attachments
end
