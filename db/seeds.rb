# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"

puts 'Destroying database'
Listing.destroy_all
User.destroy_all

puts ' Creating new users..'

alexis = User.create!(email: 'alexis@change.com', password: '1234abcd')
karen = User.create!(email: 'karen@change.com', password: '123abcd')
brendan = User.create!(email: 'brendan@change.com', password: '123abc')

puts 'Creating new listings'

new_listings = [
  { name: 'Aerosmith',
    description: 'We are a rock band formed in 2020. Our love for music brought us together to play as a band.',
    images_url: ['https://www.rollingstone.com/wp-content/uploads/2021/11/aerosmith-review.jpg'],
    instruments: 'drummer',
    liked_genres: 'Heavy Metal',
    liked_bands: 'ACDC',
    looking_for: 'vocals',
    user: alexis },

  { name: 'Coldplay',
    description: 'We are a band formed in 2021. We have 3 members in our band and love to jam together',
    images_url: ['https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/ColdplayBBC071221_%28cropped%29.jpg/600px-ColdplayBBC071221_%28cropped%29.jpg', 'https://dx35vtwkllhj9.cloudfront.net/trafalgarreleasing/coldplay-music-of-the-spheres/images/regions/intl/onesheet.jpg'],
    instruments: 'vocals',
    liked_genres: 'Rock',
    liked_bands: 'Chris Martins',
    looking_for: 'vocals',
    user: alexis },

  { name: 'Elijah Woods',
    description: 'I am a soloist who jams often at Orchard Road.',
    images_url: ['https://static.wixstatic.com/media/d0195f_aaa4eb044a8f4921b35db2ab02f64951~mv2.jpg/v1/fill/w_980,h_1222,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/d0195f_aaa4eb044a8f4921b35db2ab02f64951~mv2.jpg'],
    instruments: 'vocals',
    liked_genres: 'Jazz',
    liked_bands: 'Jamie Fine',
    looking_for: 'guitarist',
    user: karen },

  { name: 'Niall Horan',
    description: 'I am a soloist who jams often at Orchard Road.',
    images_url: ['https://upload.wikimedia.org/wikipedia/commons/1/16/Niall_Horan_on_iHeartRadio_Canada_in_2023_%281%29_%28cropped%29.png', 'https://cdn.apollo.audio/one/media/6275/307e/2171/c63a/14e6/6f35/niall-horan-career.jpg'],
    instruments: 'vocals',
    liked_genres: 'Soft Pop, Pop Rock',
    liked_bands: 'One Direction',
    looking_for: 'drummer',
    user: karen },

  { name: 'We is One',
    description: 'We are a group of friends who come together to play for fun. We would want to move towards busking on the streets.',
    images_url: ['https://floodlightz.com/wp-content/uploads/2024/04/indian-ocean-band.jpg', 'https://www.musicgrotto.com/wp-content/uploads/2022/05/band-playing-music-illustration-graphic-art.jpg'],
    instruments: 'drummer, guitarist, vocals',
    liked_genres: 'Pop Punk, Jazz',
    liked_bands: 'G-Idle',
    looking_for: 'keyboardist',
    user: brendan }
]

new_listings.each do |attributes|
  listing = Listing.new(attributes.except(:images_url))

  attributes[:images_url].each do |url|
    file = URI.open(url)
    listing.images.attach(io: file, filename: "img", content_type: "image/jpg")
  end

  sound_clip = File.open('db/sound_clips/bell.mp3')
  listing.sound_clip.attach(io: sound_clip, filename: "sound_clip", content_type: "audio/mp3")
  listing.save!

  puts "Created #{listing.name}"
end
puts 'Finished!'
