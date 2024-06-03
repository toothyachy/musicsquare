require 'date'

class AvailabilitiesController < ApplicationController

  def index
    listing = params[:listing_id]
    availabilities = Availability.where(listing: listing)
    @requests = Request.where(listing: listing)
    bookings = []
    @requests.each do |request|
      if request.booked_time != nil
        parsed_time = DateTime.parse(request.booked_time)
        bookings << parsed_time
      end
    end
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
  available_slots.each do |slot|
    if bookings.include?(slot[:start_time])
      available_slots.delete(slot)
    end
  end
  available_slots
end
end
