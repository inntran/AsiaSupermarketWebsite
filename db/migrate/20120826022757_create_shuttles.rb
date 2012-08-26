class CreateShuttles < ActiveRecord::Migration
  def change
    create_table :shuttles do |t|
      t.string :name
      t.string :first_dayofweek
      t.string :first_timeofday
      t.string :second_dayofweek
      t.string :second_timeofday
      t.integer :capacity

      t.timestamps
    end
  end
end
