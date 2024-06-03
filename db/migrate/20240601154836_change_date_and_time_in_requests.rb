class ChangeDateAndTimeInRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :request_date, :string
    add_column :requests, :request_time, :string
    remove_column :requests, :date, :date
    remove_column :requests, :start_time, :time
    remove_column :requests, :end_time, :time
  end
end
