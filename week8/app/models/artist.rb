class Artist < ActiveRecord::Base
  attr_accessible :scenic_name, :bio, :album_id
  attr_accessible :album_attributes # for nested removal
  has_many :albums
  has_many :songs, through: :albums
  accepts_nested_attributes_for :albums, :reject_if => lambda { |a| a[:title].blank? }
end