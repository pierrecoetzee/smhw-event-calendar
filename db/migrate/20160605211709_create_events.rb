class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :start_date
      t.date :end_date
      t.string :title
      t.text :subject

      t.timestamps null: false
    end
  end
end
