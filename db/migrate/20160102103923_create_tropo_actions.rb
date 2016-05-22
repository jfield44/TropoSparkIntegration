class CreateTropoActions < ActiveRecord::Migration
  def change
    create_table :tropo_actions do |t|
      t.string :recipient
      t.string :delivery_type
      t.text :message

      t.timestamps null: false
    end
  end
end
