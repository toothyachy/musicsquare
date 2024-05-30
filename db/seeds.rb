# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Destroying database'
Listing.destroy_all

puts 'Creating new listings'

new_listings = [
  { name: '',
    description: '',
    instrument: '',
    genre: '',
    looking_for: '',
    sound_clips: '' },
  {}
]


flat_seeds.each do |attributes|
  flat = Flat.create!(attributes)
  puts "Created #{flat.name}"
end
puts 'Finished!'
