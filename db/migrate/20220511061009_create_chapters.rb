class CreateChapters < ActiveRecord::Migration[6.0]
  def change
    create_table :chapters do |t|
      t.integer :chapter_number
      t.string :body
      t.references :book

      t.timestamps
    end
  end
end
