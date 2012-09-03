class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :name
      t.references :shuttle

      t.timestamps
    end
  end
end
