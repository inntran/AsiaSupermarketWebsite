require 'spec_helper'

describe Booking do
  it "has a valid factory" do
    booking = FactoryGirl.create(:booking)
    booking.should be_valid
  end

  it "is not valid without a name" do
    FactoryGirl.build(:booking, :customer => nil).should_not be_valid
  end

  it "is not valid without a shuttle" do
    FactoryGirl.build(:booking, :shuttle => nil).should_not be_valid
  end

  it "selects 1st shuttle with a population less than one shuttle capacity" do
    shuttle = FactoryGirl.create(:shuttle, :capacity => 17)
    stop = FactoryGirl.create(:stop, :shuttle => shuttle)
    16.times do 
      FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
    end
    shuttle.population(1).should == 16
    # TODO: selection
  end

  it "selects 2nd shuttle with a population more than one shuttle capacity" do
    shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 20)
    stop = FactoryGirl.create(:stop, :shuttle => shuttle)

    39.times do
      FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
    end
    shuttle.population.should == 39
    shuttle.population(1).should == 20
    shuttle.population(2).should == 19
  end

  it "is not valid with more than 2 * capacity in a shuttle line with 2 shuttles" do
    shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 20)
    stop = FactoryGirl.create(:stop, :shuttle => shuttle)

    39.times {FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)}
    FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle).should be_valid
    FactoryGirl.build(:booking, :stop => stop, :shuttle => shuttle).should_not be_valid
  end

  it "falls back to the 1st shuttle if population is greater than or equal to 20 and the population of 1st is less than 20" do
    shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 20)
    stop = FactoryGirl.create(:stop, :shuttle => shuttle)

    b_1 = FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
    20.times {FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)}
    shuttle.population(1).should == 20
    shuttle.population(2).should == 1
    b_1.shuttle_sequence.should == 1

    b_1.destroy
    shuttle.population(1).should == 19
    b_22 = FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
    b_22.shuttle_sequence.should == 1

    b_23 = FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
    b_23.shuttle_sequence.should == 2
  end

  it "is not legal to select 2nd shuttle if there's only one shuttle" do
    shuttle = FactoryGirl.create(:shuttle)
    stop = FactoryGirl.create(:stop, :shuttle => shuttle)
    19.times {FactoryGirl.create(:booking, :shuttle => shuttle, :stop => stop)}
    FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle).should be_valid
    FactoryGirl.build(:booking, :shuttle => shuttle, :stop => stop).should_not be_valid
  end

end
