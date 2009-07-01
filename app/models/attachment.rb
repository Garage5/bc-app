class Attachment < ActiveRecord::Base
  belongs_to :attachble, :polymorphic => true
  
  has_attached_file :attachment, :styles => {:thumb => '100x100>'}, :whiny => false

  def image?
    !(attachment_content_type =~ /^image.*/).nil?
  end
end
