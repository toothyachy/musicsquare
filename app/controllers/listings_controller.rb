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

  def mylistings
    @list = current_user.listings
  end

  def new
    @listing = Listing.new
    @availability = @listing.availabilities.build
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    if @listing.save
      # To update path to listing_path(@listing) when show.html.erb view is up
      redirect_to listings_my_listings_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @listing.update(listing_params)
    if @listing.save
      # To update path to listing_path(@listing) when show.html.erb view is up
      redirect_to listings_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_my_listings_path, status: :see_other
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

  private
  def listing_params
    params.require(:listing).permit(:name, :description, :sound_clip, :instruments, :liked_genres, :liked_bands, :looking_for, availabilities_attributes: [:id, :date_range, :day, :start_time, :end_time], images: [])
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
end
