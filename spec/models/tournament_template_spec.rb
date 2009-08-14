require File.dirname(__FILE__) + '/../spec_helper'

describe TournamentTemplate do
  it "should be valid" do
    TournamentTemplate.new.should be_valid
  end
end
