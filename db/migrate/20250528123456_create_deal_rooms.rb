class CreateDealRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :deal_rooms do |t|
      t.string :name, null: false
      t.integer :stage, null: false, default: 0
      t.references :lead, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end