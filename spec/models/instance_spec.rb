require File.dirname(__FILE__) + '/../spec_helper'

describe Instance do
  it "should be valid" do
    Instance.new.should be_valid
  end
end
