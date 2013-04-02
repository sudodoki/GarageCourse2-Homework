# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# FactoryGirl.find_definitions

# We could have defined nested factories in factories,
# but who knows when we may need those.
10.times do
  sampleArtist = Artist.new do |a|
    a.scenic_name = %w|Liza Joe Samuel Nadine|.sample
    a.bio = "The look in your eyes, I recognize it. You used to have it for me."
  end
  rand(8).times do
    sampleAlbum = Album.new do |al|
      al.title = %w|Eeny Meeny Miny Moe|.sample
      al.year = 1990 + rand(20)
      rand(8).times do
        al.songs << Song.create do |s|
          s.artist = sampleArtist
          s.title = %w|Snow Fire Ice Windy|.sample + ' ' + %w|Day Lake Highway Heart|.sample
          s.duration = 60 + rand(30)
          s.genre = %w|Blues Disco Rock Electronic|.sample
        end
      end
    end
    sampleArtist.albums << sampleAlbum
  end
  sampleArtist.save
end