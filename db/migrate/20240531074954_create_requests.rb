class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.string :requestor_comment
      t.string :approver_comment
      t.string :status, default: "pending"
      t.date :date
      t.time :start_time
      t.time :end_time
      t.references :user, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
