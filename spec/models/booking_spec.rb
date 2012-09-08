require 'spec_helper'

describe Booking do
  it "has a token that can be found" do
    booking = FactoryGirl.create(:booking)
    token = booking.token
    booking_tobe_deleted = Booking.find_by_token(token)
    booking_tobe_deleted.destroy
    lambda { Booking.find(booking)}.should raise_error(ActiveRecord::RecordNotFound)
  end

  context "basic validation" do
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
  end

  context "only one shuttle" do
    it "selects 1st shuttle with population less than the capacity" do
      shuttle = FactoryGirl.create(:shuttle, :capacity => 5)
      stop = FactoryGirl.create(:stop, :shuttle => shuttle)
      4.times do 
        FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
      end
      shuttle.population(1).should == 4
    end

    it "doesn't select 2nd shuttle if there's only one shuttle" do
      shuttle = FactoryGirl.create(:shuttle, :capacity => 5)
      stop = FactoryGirl.create(:stop, :shuttle => shuttle)
      shuttle.shuttle_count.should == 1

      4.times {FactoryGirl.create(:booking, :shuttle => shuttle, :stop => stop)}
      shuttle.population(1).should == 4

      FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
      shuttle.population(1).should == 5

      FactoryGirl.build(:booking, :stop => stop, :shuttle => shuttle).should_not be_valid
      shuttle.population(2).should == 0
      shuttle.population(1).should == 5
    end
  end

  context "two shuttles" do
    it "selects 2nd shuttle with a population more than one shuttle capacity if there are 2 shuttles" do
      shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 5)
      stop = FactoryGirl.create(:stop, :shuttle => shuttle)

      9.times {FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)}
      shuttle.population.should == 9
      shuttle.population(1).should == 5
      shuttle.population(2).should == 4
    end

    it "is not valid with population more than 2 * capacity in a shuttle line with 2 shuttles" do
      shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 5)
      stop = FactoryGirl.create(:stop, :shuttle => shuttle)

      9.times {FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)}
      FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
      FactoryGirl.build(:booking, :stop => stop, :shuttle => shuttle).should_not be_valid
    end

    it "falls back to the 1st shuttle if population is greater than or equal to 5 and the population of 1st is less than 5" do
      shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 5)
      stop = FactoryGirl.create(:stop, :shuttle => shuttle)

      # Create the first booking
      b_1 = FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)

      # Added 20 bookings which lead to 21 bookings in total
      5.times {FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)}
      shuttle.population(1).should == 5
      shuttle.population(2).should == 1

      # The first booking has a sequence number of 1
      b_1.shuttle_sequence.should == 1

      # Destroy the first booking
      b_1.destroy
      shuttle.population(1).should == 4
      shuttle.population(2).should == 1

      # Added another booking after deleted the first one
      b_7 = FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
      b_7.shuttle_sequence.should == 1

      # Added another booking
      b_8 = FactoryGirl.create(:booking, :stop => stop, :shuttle => shuttle)
      b_8.shuttle_sequence.should == 2
      shuttle.population(1).should == 5
      shuttle.population(2).should == 2
    end
  end

end
