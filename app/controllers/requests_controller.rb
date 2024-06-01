require "time"

class RequestsController < ApplicationController

  def new
    @request = Request.new
    @listing = set_listing
    availability = Availability.where(listing: @listing)
    @slots = []
    start_time = availability[0].start_time
    end_time = availability[0].end_time
    (start_time.to_i...end_time.to_i).step(3600) do |time|
      @slots << Time.at(time).in_time_zone(start_time.time_zone).strftime("%H:%M")
    end
  end

  # "start_time"=>"14:00",
  # "end_time"=>"16:00",

  def create
    @request = Request.new(request_params)
    @request.user = current_user
    @request.listing = set_listing
    if @request.save
      # To update path to listing_path(@listing) when show.html.erb view is up
      redirect_to listings_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def request_params
    params.require(:request).permit(:requestor_comment, :approver_comment, :status, :date, :start_time, :end_time)
  end

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end
end
