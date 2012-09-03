class Booking < ActiveRecord::Base
  attr_accessible :customer, :email, :phone_number, :shuttle_id, :shuttle_sequence, :stop_id

  belongs_to :shuttle
  belongs_to :stop

  validates :customer, :shuttle_id, :stop_id, :presence => true
  validates :shuttle_sequence, :inclusion => [1,2]
end
