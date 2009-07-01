require File.dirname(__FILE__) + '/../spec_helper'

describe Attachment do
  it "should be valid" do
    Attachment.new.should be_valid
  end
end
