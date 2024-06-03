require "time"

class RequestsController < ApplicationController

  def index
    @requests = current_user.requests
    @pending = @requests.where(status: 'pending')
    @accepted = @requests.where(status: 'accept')
    @decline = @requests.where(status: 'decline')
    # @requests.each do |request|
    #   request.where(status: 'accept')
    #     accepted <<
    #   elsif request.status == 'pending'
    #     pending << request
    #   elsif request.status == 'decline'
    #     decline << request
    #   end
  end

  def myqueue
  end

  def new
    @request = Request.new
    @listing = set_listing
    # availability = Availability.where(listing: @listing)
    # @slots = []
    # start_time = availability[0].start_time
    # end_time = availability[0].end_time
    # (start_time.to_i...end_time.to_i).step(3600) do |time|
    #   @slots << Time.at(time).in_time_zone(start_time.time_zone).strftime("%H:%M")
    # end
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

  def accept
    @request = Request.find(params[:id])
    @request.update(status: "accept")
    @request.update(booked_time: '2024-07-03T19:00:00.000+00:00')
    raise
  end

  def decline
    raise
  end

  private
  def request_params
    params.require(:request).permit(:requestor_comment, :approver_comment, :status, :date, :start_time, :end_time)
  end

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end
end


# listen to approve/decline
# if approve, change status to 'approve', save request_time and request_date to booked_time
# if decline, change status to 'decline'
