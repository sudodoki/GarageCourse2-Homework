class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  attr_accessible :title, :duration, :genre
  def scenic_name
    artist.scenic_name || 'noone'
  end
  def readeable_duration
    format("%02d:%02d", (duration / 60), duration % 60)
  end
end