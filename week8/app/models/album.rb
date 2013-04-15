class Album < ActiveRecord::Base
  attr_accessible :title, :year, :artist_id
  attr_accessible :songs_attributes # for nested removal
  has_many :songs, :dependent => :destroy
  belongs_to :artist
  accepts_nested_attributes_for :songs, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true

end