class Shuttle < ActiveRecord::Base
  attr_accessible :capacity, :first_dayofweek, :first_timeofday, :name, :second_dayofweek, :second_timeofday

  validates :name, :presence => true
  validates :first_timeofday, :first_dayofweek, :presence => true
  validate :incomplete_second_shuttle
  
  def incomplete_second_shuttle
    if second_dayofweek.empty? == true && second_timeofday.empty? == false
      errors.add(:second_dayofweek, "can't be empty with 2nd shuttle time of day set")
    elsif second_timeofday.empty? == true && second_dayofweek.empty? == false
      errors.add(:second_timeofday, "can't be empty with 2 shuttle day of week set")
    end
  end
end
