require File.dirname(__FILE__) + '/../spec_helper'

describe Round do
  it "should be valid" do
    Round.new.should be_valid
  end
end
