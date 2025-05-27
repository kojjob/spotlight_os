class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :assistant, null: false, foreign_key: true
      t.datetime :scheduled_at
      t.integer :duration
      t.string :status
      t.string :external_id
      t.string :external_link
      t.jsonb :metadata

      t.timestamps
    end
  end
end
