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
      :first_dayofweek => "Wed", :first_timeofday => "2:31PM",
      :second_dayofweek => "Fri", :second_timeofday => "5:01PM").should be_valid
  end

  it "is not valid with only time or day in 2nd shuttle" do
    FactoryGirl.build(:shuttle, :second_dayofweek => "Sat").should_not be_valid
    FactoryGirl.build(:shuttle, :second_timeofday => "9:02AM").should_not be_valid
  end

  it "returns 2 if it has second shuttle defined" do
    shuttle = FactoryGirl.build(:shuttle, :second_dayofweek => "Fri", :second_timeofday => "5:03PM")
    shuttle.shuttle_count.should == 2
  end

  it "returns 2nd shuttle information if requested" do
    shuttle = FactoryGirl.build(:shuttle, :second_dayofweek => "Fri", :second_timeofday => "5:04PM")
    shuttle.shuttle_info(2).should == {:dayofweek => "Fri", :timeofday => "5:04PM"}
  end

  it "returns 1st shuttle information if requested" do
    shuttle = FactoryGirl.build(:shuttle)
    shuttle.shuttle_info(1).should == {:dayofweek => "Friday", :timeofday => "5:20PM"}
  end

  context "returns current available shuttle" do
    it "with 1 shuttle" do
      shuttle = FactoryGirl.create(:shuttle, :capacity => 5)
      stop = FactoryGirl.create(:stop, :shuttle => shuttle)
      4.times {FactoryGirl.create(:booking, :shuttle => shuttle, :stop => stop)}
      shuttle.available.should == 1
    end

    context "with 2 shuttles" do
      before(:each) do
        @shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Fri", :second_timeofday => "5:07PM", :capacity => 5)
        @stop = FactoryGirl.create(:stop, :shuttle => @shuttle)
      end

      it "less than 1 * capacity" do
        4.times {FactoryGirl.create(:booking, :shuttle => @shuttle, :stop => @stop)}
        @shuttle.available.should == 1
      end

      it "has 1 * capacity population" do
        5.times {FactoryGirl.create(:booking, :shuttle => @shuttle, :stop => @stop)}
        @shuttle.available.should == 2
      end

      it "has more than 1 * capacity population in total" do
        7.times {FactoryGirl.create(:booking, :shuttle => @shuttle, :stop => @stop)}
        @shuttle.available.should == 2
      end

      it "has 2 * capacity population in total" do
        10.times {FactoryGirl.create(:booking, :shuttle => @shuttle, :stop => @stop)}
        @shuttle.available.should == nil
      end

      it "falls back to No.1 with some booking deleted from No.1" do
        b_1 = FactoryGirl.create(:booking, :shuttle => @shuttle, :stop => @stop) 
        7.times {FactoryGirl.create(:booking, :shuttle => @shuttle, :stop => @stop)}
        @shuttle.available.should == 2
        b_1.destroy
        @shuttle.available.should == 1
      end
    end
  end
end
