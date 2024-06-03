class AddDaterangeAndDayToAvailabilities < ActiveRecord::Migration[7.1]
  def change
    add_column :availabilities, :date_range, :string
    add_column :availabilities, :day, :string
    change_column :availabilities, :start_time, :string
    change_column :availabilities, :end_time, :string
    remove_column :availabilities, :date, :date
  end
end
