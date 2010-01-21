class Event < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  named_scope :sans_private, :conditions => ['event_type != ?', 'private_message']
  
  
  serialize :data, Hashie::Mash
  
  belongs_to :tournament, :touch => true
  belongs_to :target, :polymorphic => true
  
  def event_type
    read_attribute(:event_type) == 'private_message' ? 'message' : read_attribute(:event_type)
  end
end
