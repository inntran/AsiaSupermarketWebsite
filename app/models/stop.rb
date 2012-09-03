class Stop < ActiveRecord::Base
  attr_accessible :name, :shuttle_id
  belongs_to :shuttle

  validates :name, :presence => true
end
