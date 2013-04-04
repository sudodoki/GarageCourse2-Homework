class Album < ActiveRecord::Base
  attr_accessible :title, :year
  attr_accessible :songs_attributes # for nested removal
  attr_accessible :artist_id # for nested appending
  has_many :songs, :dependent => :destroy
  belongs_to :artist
  accepts_nested_attributes_for :songs, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

end