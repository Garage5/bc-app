class Instance < ActiveRecord::Base
  has_many :tournaments
  has_many :templates, :class_name => "Tournament", :foreign_key => "instance_id", :conditions => {:is_template => true}
  belongs_to :host, :class_name => 'User'
  
  has_attached_file :logo
  
  ALLOWED_DOMAINS = [
    'tbbhere.com',
    'tbblive.com',
    'tbbnow.com',
    'tbbonline.com'
  ]

  validates_presence_of :name
  validates_uniqueness_of :name
end
