class Tournament < ActiveRecord::Base
  belongs_to  :instance
  has_many    :messages
end
