require 'date'
require 'json'

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
  return date_slots.to_json
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

availability = {
   "daterange"=>"2024-06-11 to 2024-07-20",
   "day"=>"Monday",
   "start_time"=>"14:00",
   "end_time"=>"16:00",
  }

  puts set_date_slots(availability)
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



# availabilities = [
#   { date: Date.parse("3 June 2024"),
#   start_time: DateTime.parse("3 June 2024 15:00:00"),
#   end_time: DateTime.parse("3 June 2024 19:00:00"),
#   listing: Listing.first
#   },
#   { date: Date.parse("7 June 2024"),
#   start_time: DateTime.parse("7 June 2024 18:00:00"),
#   end_time: DateTime.parse("7 June 2024 22:00:00"),
#   listing: Listing.first
#   },
#   { date: Date.parse("7 June 2024"),
#   start_time: DateTime.parse("7 June 2024 14:00:00"),
#   end_time: DateTime.parse("7 June 2024 16:00:00"),
#   listing: Listing.first
#   },
#   { date: Date.parse("8 June 2024"),
#   start_time: DateTime.parse("8 June 2024 12:00:00"),
#   end_time: DateTime.parse("8 June 2024 18:00:00"),
#   listing: Listing.first
#   },
#   { date: Date.parse("11 June 2024"),
#   start_time: DateTime.parse("11 June 2024 19:00:00"),
#   end_time: DateTime.parse("11 June 2024 21:00:00"),
#   listing: Listing.first
#   },
#   { date: Date.parse("13 June 2024"),
#   start_time: DateTime.parse("13 June 2024 15:00:00"),
#   end_time: DateTime.parse("13 June 2024 19:00:00"),
#   listing: Listing.first
#   },
#   { date: Date.parse("2 June 2024"),
#   start_time: DateTime.parse("2 June 2024 14:00:00"),
#   end_time: DateTime.parse("2 June 2024 22:00:00"),
#   listing: Listing.second
#   },
#   { date: Date.parse("4 June 2024"),
#   start_time: DateTime.parse("4 June 2024 12:00:00"),
#   end_time: DateTime.parse("4 June 2024 18:00:00"),
#   listing: Listing.second
#   },
#   { date: Date.parse("7 June 2024"),
#   start_time: DateTime.parse("7 June 2024 19:00:00"),
#   end_time: DateTime.parse("7 June 2024 21:00:00"),
#   listing: Listing.second
#   },
#   { date: Date.parse("9 June 2024"),
#   start_time: DateTime.parse("9 June 2024 15:00:00"),
#   end_time: DateTime.parse("9 June 2024 19:00:00"),
#   listing: Listing.second
#   },
# ]

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
