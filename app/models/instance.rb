class Instance < ActiveRecord::Base
  has_many :tournaments
  
  validates_presence_of :name
end
