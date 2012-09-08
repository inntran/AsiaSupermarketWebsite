class Booking < ActiveRecord::Base
  attr_accessible :customer, :email, :phone_number, :shuttle_id, :stop_id, :stop, :shuttle

  belongs_to :shuttle
  belongs_to :stop

  validates :customer, :shuttle_id, :stop_id, :presence => true
  # validates :shuttle_sequence, :inclusion => [1,2] , :unless => "shuttle_sequence.nil?"
  validate :shuttle_capacity, :unless => "shuttle.nil?"
  after_validation :set_shuttle_sequence, :unless => "shuttle.nil?"

private

  def set_shuttle_sequence
    if shuttle.shuttle_count == 1 
      if shuttle.population <= shuttle.capacity
        self.shuttle_sequence = 1
      end

    elsif shuttle.shuttle_count == 2
      if shuttle.population(1) <= (shuttle.capacity - 1)
        self.shuttle_sequence = 1
      elsif shuttle.population(2) < shuttle.capacity && shuttle.population(1) == shuttle.capacity
        self.shuttle_sequence = 2
      end
    end

  end

  def shuttle_capacity
    if shuttle.shuttle_count == 1 && shuttle.population(1) == shuttle.capacity
      errors.add(:shuttle_sequence, "No.1 is full")
    elsif shuttle.shuttle_count == 2 && shuttle.population == (2 * shuttle.capacity)
      errors.add(:shuttle_sequence, "No.2 is overloaded")
    end
  end
 
end
