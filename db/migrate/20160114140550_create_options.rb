class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.integer :votes

      t.timestamps null: false
    end
  end
end
