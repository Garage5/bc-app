class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  has_many :attachments, :as => :attachable, :class_name => '::Attachment'
  
  validates_presence_of :body
  
  accepts_nested_attributes_for :attachments
  
  after_create do |e|
    Event.create(
      :tournament_id => e.commentable.tournament_id,
      :target_id     => e.id,
      :target_type   => e.class.to_s,
      :event_type    => 'comment',
      :message       => 're: ' + e.commentable.subject,
      :action        => 'posted',
      :actor         => e.author.login
    )
  end
end
