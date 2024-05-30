class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.string :name
      t.text :description
      t.string :sound_clip
      t.string :images, array: true
      t.string :instruments
      t.string :liked_genres
      t.string :liked_bands
      t.string :looking_for
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
