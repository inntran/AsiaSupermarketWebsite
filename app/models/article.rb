class Article < ActiveRecord::Base
  belongs_to :category
  attr_accessible :content, :title, :category_id

  validates :title, :content, :category_id, :presence => true
end
