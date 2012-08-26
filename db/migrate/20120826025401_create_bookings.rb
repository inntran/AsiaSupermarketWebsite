class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :customer
      t.string :phone_number
      t.string :email
      t.references :shuttle_id
      t.integer :shuttle_sequence
      t.references :stop_id

      t.timestamps
    end
  end
end
