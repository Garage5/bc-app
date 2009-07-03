class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  belongs_to :tournament
  belongs_to :uploader, :class_name => "User", :foreign_key => "uploader_id"
  
  has_attached_file :attachment, :styles => {:thumb => '100x100>'}, :whiny => false
  
  def image?
    !(attachment_content_type =~ /^image.*/).nil?
  end
end
