require 'date'
require 'json'

class ListingsController < ApplicationController
  before_action :set_listing, only: [ :show, :edit, :update, :destroy ]
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @listings = Listing.all
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.images << listing_params[:images]
    raise
    @listing.user = current_user
    if @listing.save
      # To update path to listing_path(@listing) when show.html.erb view is up
      redirect_to listings_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @listing.update(listing_params)
    @listing.images << listing_params[:images]
    if @listing.save
      # To update path to listing_path(@listing) when show.html.erb view is up
      redirect_to listings_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_path, status: :see_other
  end

  def filter
    # genres = set_genres
    # genres = JSON.parse(genres)
    genres = ["Heavy Metal", "Jazz", "Soft Pop", "Pop Rock", "Pop Punk", "Rock", "Death Metal", "Goth", "Punk", "Japanese Rock", "Ballads"]
    @selected_genres = genres.sample(3)
    musicians = Listing::MUSICIANS
    @selected_musicians = musicians.sample(3)

    @only_musician = []
    @only_genre = []
    @and_list = []
    @or_list = []

    @selected_musicians.each do |musician|
      @only_musician += Listing.where(looking_for: musician)
    end

    @selected_genres.each do |genre|
      @only_genre += Listing.where("liked_genres ILIKE ?", "%#{genre}%")
    end

    @and_list = @only_musician & @only_genre
    @or_list = (@only_musician - @only_genre) | (@only_genre - @only_musician)

  end

  def availability
    availability = {
      "daterange"=>"2024-06-11 to 2024-07-20",
      "day"=>"Monday",
      "start_time"=>"14:00",
      "end_time"=>"16:00",
      }
    dates = set_date_slots(availability)
    render json: dates
  end

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :sound_clip, :images, :instruments, :liked_genres, :liked_bands, :looking_for)
  end

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def set_genres
    @listings = Listing.all
    genres = @listings.map { |listing| listing.liked_genres }
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "You are an expert in identifying music genres. Here is a list of music genres: #{genres}. Identify the key genre types contained within and provide me with an array of the key genre types. Respond with only an array of strings and omit all other text."}]
    })
    @content = chaptgpt_response["choices"][0]["message"]["content"]
  end

  def set_available_slots(availability)
    start_date, end_date = availability['daterange'].split(' to ').map { |date| Date.parse(date) }
    day_of_week = Date::DAYNAMES.index(availability['day'])
    start_time = DateTime.parse(availability['start_time'])
    end_time = DateTime.parse(availability['end_time'])

    available_slots = []

    (start_date..end_date).each do |date|
      if date.wday == day_of_week
        current_time = DateTime.new(date.year, date.month, date.day, start_time.hour, start_time.minute, start_time.second, start_time.zone)
        end_limit = DateTime.new(date.year, date.month, date.day, end_time.hour, end_time.minute, end_time.second, end_time.zone)
        while current_time + 1/24r <= end_limit
          available_slots << { date: date, start_time: current_time, end_time: current_time + 1/24r }
          current_time += 1/24r
        end
      end
    end

    available_slots
  end

  def set_date_slots(availability)
    available_slots = set_available_slots(availability)
    date_slots = available_slots.map { |slot| slot[:date] }
    return date_slots
    # return { dates: date_slots.to_json }
  end

  # individual booking must be of same format as available slots e.g.
  # booked_slots = [available_slots[0], available_slots[1], available_slots[3]]

  def get_current_available_slots(availability, bookings)
    available_slots = set_available_slots(availability)
    puts available_slots

    # Remove booked slots from available slots
    current_available_slots = available_slots - bookings

    puts "Available slots after booking:"
    current_available_slots.each do |slot|
      puts "#{slot[:date]} - #{slot[:start_time]} to #{slot[:end_time]}"
    end

    current_available_slots
  end
end



#   puts set_date_slots(availability)
# puts set_available_slots(availability)

# [{:date=>#<Date: 2024-06-17 ((2460479j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-06-17T14:00:00+00:00 ((2460479j,50400s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-06-17T15:00:00+00:00 ((2460479j,54000s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-06-17 ((2460479j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-06-17T15:00:00+00:00 ((2460479j,54000s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-06-17T16:00:00+00:00 ((2460479j,57600s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-06-24 ((2460486j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-06-24T14:00:00+00:00 ((2460486j,50400s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-06-24T15:00:00+00:00 ((2460486j,54000s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-06-24 ((2460486j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-06-24T15:00:00+00:00 ((2460486j,54000s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-06-24T16:00:00+00:00 ((2460486j,57600s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-07-01 ((2460493j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-07-01T14:00:00+00:00 ((2460493j,50400s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-07-01T15:00:00+00:00 ((2460493j,54000s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-07-01 ((2460493j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-07-01T15:00:00+00:00 ((2460493j,54000s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-07-01T16:00:00+00:00 ((2460493j,57600s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-07-08 ((2460500j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-07-08T14:00:00+00:00 ((2460500j,50400s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-07-08T15:00:00+00:00 ((2460500j,54000s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-07-08 ((2460500j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-07-08T15:00:00+00:00 ((2460500j,54000s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-07-08T16:00:00+00:00 ((2460500j,57600s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-07-15 ((2460507j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-07-15T14:00:00+00:00 ((2460507j,50400s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-07-15T15:00:00+00:00 ((2460507j,54000s,0n),+0s,2299161j)>},
# {:date=>#<Date: 2024-07-15 ((2460507j,0s,0n),+0s,2299161j)>, :start_time=>#<DateTime: 2024-07-15T15:00:00+00:00 ((2460507j,54000s,0n),+0s,2299161j)>, :end_time=>#<DateTime: 2024-07-15T16:00:00+00:00 ((2460507j,57600s,0n),+0s,2299161j)>}]
# Available slots after booking:
# 2024-06-24 - 2024-06-24T14:00:00+00:00 to 2024-06-24T15:00:00+00:00
# 2024-07-01 - 2024-07-01T14:00:00+00:00 to 2024-07-01T15:00:00+00:00
# 2024-07-01 - 2024-07-01T15:00:00+00:00 to 2024-07-01T16:00:00+00:00
# 2024-07-08 - 2024-07-08T14:00:00+00:00 to 2024-07-08T15:00:00+00:00
# 2024-07-08 - 2024-07-08T15:00:00+00:00 to 2024-07-08T16:00:00+00:00
# 2024-07-15 - 2024-07-15T14:00:00+00:00 to 2024-07-15T15:00:00+00:00
# 2024-07-15 - 2024-07-15T15:00:00+00:00 to 2024-07-15T16:00:00+00:00
