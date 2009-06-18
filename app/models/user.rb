class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_acceptance_of :terms_of_service, :on => :create
  validates_length_of :login, :within => 3..13
end