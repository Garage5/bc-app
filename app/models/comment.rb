class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  has_many :attachments, :as => :attachable, :class_name => '::Attachment'
  
  validates_presence_of :body
  
  accepts_nested_attributes_for :attachments
  
  after_create do |e|
    Event.create(
      :tournament_id => e.commentable.tournament_id,
      :event_type    => 'comment',
      :data => Hashie::Mash.new({
        :author => e.author.login,
        :commentable => {
          :id => e.commentable.id,
          :subject => e.commentable.subject,
          :class => e.commentable_type
        }
      })
    )
  end
end
