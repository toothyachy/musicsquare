# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'date'

puts 'Destroying database'
Availability.destroy_all
Request.destroy_all
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
    sound_clip: '',
    images: ['https://www.rollingstone.com/wp-content/uploads/2021/11/aerosmith-review.jpg'],
    instruments: 'drummer',
    liked_genres: 'Heavy Metal',
    liked_bands: 'ACDC',
    looking_for: 'vocals',
    user: alexis },

  { name: 'Coldplay',
    description: 'We are a band formed in 2021. We have 3 members in our band and love to jam together',
    sound_clip: '',
    images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/ColdplayBBC071221_%28cropped%29.jpg/600px-ColdplayBBC071221_%28cropped%29.jpg', 'https://dx35vtwkllhj9.cloudfront.net/trafalgarreleasing/coldplay-music-of-the-spheres/images/regions/intl/onesheet.jpg'],
    instruments: 'vocals',
    liked_genres: 'Rock',
    liked_bands: 'Chris Martins',
    looking_for: 'vocals',
    user: alexis },

  { name: 'Elijah Woods',
    description: 'I am a soloist who jams often at Orchard Road.',
    sound_clip: '',
    images: ['https://static.wixstatic.com/media/d0195f_aaa4eb044a8f4921b35db2ab02f64951~mv2.jpg/v1/fill/w_980,h_1222,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/d0195f_aaa4eb044a8f4921b35db2ab02f64951~mv2.jpg'],
    instruments: 'vocals',
    liked_genres: 'Jazz',
    liked_bands: 'Jamie Fine',
    looking_for: 'guitarist',
    user: karen },

  { name: 'Niall Horan',
    description: 'I am a soloist who jams often at Orchard Road.',
    sound_clip: '',
    images: ['https://upload.wikimedia.org/wikipedia/commons/1/16/Niall_Horan_on_iHeartRadio_Canada_in_2023_%281%29_%28cropped%29.png', 'https://cdn.apollo.audio/one/media/6275/307e/2171/c63a/14e6/6f35/niall-horan-career.jpg'],
    instruments: 'vocals',
    liked_genres: 'Soft Pop, Pop Rock',
    liked_bands: 'One Direction',
    looking_for: 'drummer',
    user: karen },

  { name: 'We is One',
    description: 'We are a group of friends who come together to play for fun. We would want to move towards busking on the streets.',
    sound_clip: '',
    images: ['https://floodlightz.com/wp-content/uploads/2024/04/indian-ocean-band.jpg', 'https://www.musicgrotto.com/wp-content/uploads/2022/05/band-playing-music-illustration-graphic-art.jpg'],
    instruments: 'drummer, guitarist, vocals',
    liked_genres: 'Pop Punk, Jazz',
    liked_bands: 'G-Idle',
    looking_for: 'keyboardist',
    user: brendan }
]

new_listings.each do |attributes|
  listing = Listing.create!(attributes)
  puts "Created #{listing.name}"
end

puts "Creating new availabilities..."

availabilities = [
  { date_range: "2024-06-11 to 2024-09-20",
  day: "Saturday",
  start_time: "14:00",
  end_time: "18:00",
  listing: Listing.first
  },
  { date_range: "2024-06-03 to 2024-08-29",
  day: "Friday",
  start_time: "18:00",
  end_time: "21:00",
  listing: Listing.second
  },
  { date_range: "2024-07-01 to 2024-10-01",
  day: "Wednesday",
  start_time: "19:00",
  end_time: "21:00",
  listing: Listing.third
  }
]

availabilities.each do |attributes|
  availability = Availability.create!(attributes)
  puts "Created availabilities for #{availability.listing.name}"
end

requests = [
  { requestor_comment: "I would love to jam with you guys!",
    user: User.last,
    listing: Listing.first,
    request_date: "2024-06-15",
    request_time: "15:00"
 },
  { requestor_comment: "Pretty pwease?",
    approver_comment: "No thanks, we don't like people who act cute.",
    status: "decline",
    user: User.second,
    listing: Listing.first,
    request_date: "2024-06-22",
    request_time: "17:00"
  },
  { requestor_comment: "Try try?",
    approver_comment: "Sure thing!",
    status: "accept",
    user: User.last,
    listing: Listing.first,
    request_date: "2024-06-29",
    request_time: "14:00"
  },
]

requests.each do |attributes|
  request = Request.create!(attributes)
  puts "Created requests for #{request.listing.name}"
end

puts 'Finished!'
