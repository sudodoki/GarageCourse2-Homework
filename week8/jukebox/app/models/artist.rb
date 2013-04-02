class Artist < ActiveRecord::Base
  attr_accessible :scenic_name, :bio
  has_many :albums
  has_many :songs, through: :albums
end