class AddBookingTimeToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :booked_time, :string
  end
end
