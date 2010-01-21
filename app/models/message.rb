class Message < ActiveRecord::Base
  has_many   :comments, :as => :commentable
  has_many   :attachments, :as => :attachable, :class_name => '::Attachment'
  
  belongs_to :tournament
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_and_belongs_to_many :subscribers, :class_name => "User",
    :join_table => 'messages_subscribers', :association_foreign_key => 'subscriber_id'
  
  validates_presence_of :subject, :body
  
  accepts_nested_attributes_for :attachments
  
  after_create :create_event
  
  def create_event
    type = 'annoucement' if self.is_announcement?
    type = 'private_message' if self.hosts_only?
    type ||= 'message'
    
    Event.create(
      :tournament_id => self.tournament_id,
      :event_type    => type,
      :data => Hashie::Mash.new({
        :id => self.id,
        :author => self.author.login,
        :subject => self.subject
      })
    )
  end
end
