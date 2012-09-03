class Shuttle < ActiveRecord::Base
  attr_accessible :capacity, :first_dayofweek, :first_timeofday, :name, :second_dayofweek, :second_timeofday

  validates :name, :presence => true
  validates :first_timeofday, :first_dayofweek, :presence => true
end
