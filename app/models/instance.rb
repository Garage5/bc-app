class Instance < ActiveRecord::Base
  has_many :tournaments
  belongs_to :host, :class_name => 'User'
  
  validates_presence_of :name
end
