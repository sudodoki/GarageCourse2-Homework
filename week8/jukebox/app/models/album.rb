class Album < ActiveRecord::Base
  attr_accessible :title, :year, :songs_attributes # the last one for nested removal
  has_many :songs, :dependent => :destroy
  belongs_to :artist
  accepts_nested_attributes_for :songs, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

end