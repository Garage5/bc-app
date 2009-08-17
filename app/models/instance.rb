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
  # validates_uniqueness_of :subdomain
  # validates_format_of     :subdomain, :with => /^[a-z][a-z0-9_]+$/
  # validates_inclusion_of  :domain, :in => ALLOWED_DOMAINS, :message => 'is not allowed'
  
  def url
    "http://#{subdomain}.#{domain}"
  end
  
end
