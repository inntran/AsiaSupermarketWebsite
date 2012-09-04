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

  it "is valid with 1st and 2nd shuttle set" do
    FactoryGirl.build(:shuttle, 
      :first_dayofweek => "Wed", :first_timeofday => "2:30PM",
      :second_dayofweek => "Fri", :second_timeofday => "5:00PM").should be_valid
  end

  it "is not valid with only time or day in 2nd shuttle" do
    FactoryGirl.build(:shuttle, :second_dayofweek => "Sat").should_not be_valid
    FactoryGirl.build(:shuttle, :second_timeofday => "9:00AM").should_not be_valid
  end

  it "returns 2 if it has second shuttle defined" do
    shuttle = FactoryGirl.build(:shuttle, :second_dayofweek => "Fri", :second_timeofday => "5:00PM")
    shuttle.shuttle_count.should == 2
  end

  it "returns 2nd shuttle information if requested" do
    shuttle = FactoryGirl.build(:shuttle, :second_dayofweek => "Fri", :second_timeofday => "5:00PM")
    shuttle.shuttle_info(2).should == {:dayofweek => "Fri", :timeofday => "5:00PM"}
  end

  it "returns 1st shuttle information if requested" do
    shuttle = FactoryGirl.build(:shuttle)
    shuttle.shuttle_info(1).should == {:dayofweek => "Friday", :timeofday => "5:20PM"}
  end

end
