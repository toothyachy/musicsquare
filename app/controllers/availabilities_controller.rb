class AvailabilitiesController < ApplicationController

  def index
    listing = params[:listing_id]
    availabilities = Availability.where(listing: listing)
    requests = Request.where(listing: listing)
    bookings = requests.map { |request| request.booked_time }
    raise
    avail_slots = []
    date_slots = []

    availabilities.each do |availability|
      avail_slots += get_current_available_slots(availability, bookings)
      date_slots += set_date_slots(avail_slots)
    end

    @slots = { avail_slots: avail_slots, date_slots: date_slots }
    render json: @slots
  end


  private

  def set_available_slots(availability)
    start_date, end_date = availability[:date_range].split(' to ').map { |date| Date.parse(date) }
    day_of_week = Date::DAYNAMES.index(availability[:day])
    start_time = DateTime.parse(availability[:start_time])
    end_time = DateTime.parse(availability[:end_time])

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

  def set_date_slots(available_slots)
    return available_slots.map { |slot| slot[:date] }
  end

  def get_current_available_slots(availability, bookings = [])
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


# listing_availabilities GET    /listings/:listing_id/availabilities(.:format) availabilities#index

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
