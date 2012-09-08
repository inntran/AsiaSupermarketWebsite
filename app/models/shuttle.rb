class Shuttle < ActiveRecord::Base
  attr_accessible :capacity, :first_dayofweek, :first_timeofday, :name, :second_dayofweek, :second_timeofday

  validates :name, :presence => true
  validates :first_timeofday, :first_dayofweek, :presence => true
  validate :incomplete_second_shuttle

  has_many :bookings
  has_many :stops

  def shuttle_count
    if second_dayofweek.empty? == true && second_timeofday.empty? == true
      return 1
    elsif second_dayofweek.empty? == false && second_timeofday.empty? == false
      return 2
    end
  end

  def shuttle_info(sequence)
    if sequence == 1
      return {:dayofweek => first_dayofweek, :timeofday => first_timeofday}
    elsif sequence == 2
      return {:dayofweek => second_dayofweek, :timeofday => second_timeofday}
    end
  end

  def population(sequence = nil)
    if sequence.nil?
      Booking.where(:shuttle_id => self.id).count
    else
      Booking.where(:shuttle_id => self.id, :shuttle_sequence => sequence).count
    end
  end

  def available
    if self.shuttle_count == 1
      (self.population < self.capacity) ? 1 : nil
    elsif self.shuttle_count == 2
      if self.population(1) < self.capacity
        1
      elsif self.population(2) < self.capacity
        2
      end
    end
  end

private

  def incomplete_second_shuttle
    if second_dayofweek.empty? == true && second_timeofday.empty? == false
      errors.add(:second_dayofweek, "can't be empty with 2nd shuttle time of day set")
    elsif second_timeofday.empty? == true && second_dayofweek.empty? == false
      errors.add(:second_timeofday, "can't be empty with 2nd shuttle day of week set")
    end
  end
end
