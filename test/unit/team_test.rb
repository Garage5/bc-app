require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  should_belong_to :tournament
  should_have_many :memberships, :dependent => :destroy
  
  should_have_many :members, :through => :memberships
  should_validate_presence_of :name
  
  should_have_db_columns :name, :tournament_id
end
