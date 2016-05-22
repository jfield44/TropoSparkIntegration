class CreateSmsRetrievals < ActiveRecord::Migration
  def change
    create_table :sms_retrievals do |t|
      t.string :phone_number
      t.string :room_id

      t.timestamps null: false
    end
  end
end
