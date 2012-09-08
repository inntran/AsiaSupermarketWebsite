class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :category
      t.string :title
      t.text :content

      t.timestamps
    end
    add_index :articles, :category_id
  end
end
