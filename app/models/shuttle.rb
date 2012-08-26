class Shuttle < ActiveRecord::Base
  attr_accessible :capacity, :first_dayofweek, :first_timeofday, :name, :second_dayofweek, :second_timeofday
end
