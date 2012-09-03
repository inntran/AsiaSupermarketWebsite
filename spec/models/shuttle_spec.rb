require 'spec_helper'

describe Shuttle do
  it "has a valid factory" do
    shuttle = FactoryGirl.build(:shuttle)
    shuttle.should be_valid
  end

  it "is not valid without a name" do
    FactoryGirl.build(:shuttle, :name => nil).should_not be_valid
  end

  it "is not valid with first shuttle empty" do
    FactoryGirl.build(:shuttle, :first_timeofday => nil, :first_dayofweek => nil).should_not be_valid
  end

  it "is valid with first and second shuttle set" do
    FactoryGirl.build(:shuttle, 
      :first_dayofweek => "Wed", :first_timeofday => "2:30PM",
      :second_dayofweek => "Fri", :second_timeofday => "5:00PM").should be_valid
  end

  it "is not valid with only time or day in second shuttle" do
    FactoryGirl.build(:shuttle, :second_dayofweek => "Sat").should_not be_valid
    FactoryGirl.build(:shuttle, :second_timeofday => "9:00AM").should_not be_valid
  end
end
