require 'spec_helper'

describe Stop do
  it "is not valid without a name" do
    FactoryGirl.build(:stop, :name => nil).should_not be_valid
  end
end
