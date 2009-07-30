class Round < ActiveRecord::Base
  named_scope :by_number, lambda {|n| {:conditions => {:number => n}}}
  
  belongs_to :tournament
  has_many   :matches
  
  acts_as_list :scope => :tournament
end
