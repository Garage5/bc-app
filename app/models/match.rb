class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :top_user, :class_name => "User", :foreign_key => "top_user_id"
  belongs_to :bottom_user, :class_name => "User", :foreign_key => "bottom_user_id"
  
  has_many :comments
end
