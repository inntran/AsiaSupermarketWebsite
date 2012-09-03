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

  it "is not valid with a shuttle sequence other than 1 or 2" do
    FactoryGirl.build(:booking, :shuttle_sequence => 3).should_not be_valid
    FactoryGirl.build(:booking, :shuttle_sequence => -1).should_not be_valid
  end

  it "is valid with a shuttle sequence 1 or 2" do
    FactoryGirl.build(:booking, :shuttle_sequence => 1).should be_valid
    FactoryGirl.build(:booking, :shuttle_sequence => 2).should be_valid
  end

end
