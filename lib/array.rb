require 'enumerator'

class Array
  def /(len); enum_for(:each_slice,len).to_a end 
end