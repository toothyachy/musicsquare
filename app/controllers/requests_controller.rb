class RequestsController < ApplicationController

  def new
    @request = Request.new
  end

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
