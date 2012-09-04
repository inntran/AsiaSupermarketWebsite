class Booking < ActiveRecord::Base
  attr_accessible :customer, :email, :phone_number, :shuttle_id, :stop_id


  belongs_to :shuttle
  belongs_to :stop

  validates :customer, :shuttle_id, :stop_id, :presence => true
  validate :set_shuttle_sequence, :unless => "shuttle.nil?"
  validates :shuttle_sequence, :inclusion => [1,2] , :unless => "shuttle_sequence.nil?"

private
  def set_shuttle_sequence
    if shuttle.shuttle_count == 1 
      if shuttle.population < shuttle.capacity
        self.shuttle_sequence = 1
      else
        errors.add(:shuttle_sequence, "overloaded")
      end

    elsif shuttle.shuttle_count == 2
      if shuttle.population(1) < shuttle.capacity
        self.shuttle_sequence = 1
      elsif shuttle.population <= (shuttle.capacity * 2)# && shuttle.population(1) == shuttle.capacity
        self.shuttle_sequence = 2
      else
        errors.add(:shuttle_sequence, "overloaded")
      end
    end

  end
end
