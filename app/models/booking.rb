class Booking < ActiveRecord::Base
  attr_accessible :customer, :email, :phone_number, :shuttle_id, :shuttle_sequence, :stop_id
end
