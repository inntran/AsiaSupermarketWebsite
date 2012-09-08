class Category < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :articles

  validates :name, :presence => true
end
