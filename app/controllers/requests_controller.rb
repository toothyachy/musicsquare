require "time"

class RequestsController < ApplicationController

  def index
    @requests = current_user.requests
    request_status
  end

  def myqueue
    @requests = current_user.queues
    request_status
  end

  def new
    @request = Request.new
    @listing = set_listing
  end

  def create
    @request = Request.new(request_params)
    @request.user = current_user
    @request.listing = set_listing
    if @request.save
      redirect_to listings_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def accept 
    @request = Request.find(params[:id])
    if @request.update(status: "accept", booked_time: @request[:request_time])
      redirect_to listings_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def decline
    @request = Request.find(params[:id])
    if @request.update(status: "decline")
      redirect_to listings_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def request_params
    params.require(:request).permit(:requestor_comment, :approver_comment, :status, :request_date, :request_time, :booked_time)
  end

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def request_status
    @pending = []
    @accepted = []
    @declined = []
    @requests.each do |request|
      if request[:status] == 'pending'
        @pending << request
      elsif request[:status] == 'accept'
        @accepted << request
      elsif request[:status] == 'decline'
        @declined << request
      end
    end
  end
end
