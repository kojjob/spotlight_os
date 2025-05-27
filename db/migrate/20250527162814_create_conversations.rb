class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :assistant, null: false, foreign_key: true
      t.string :source
      t.string :status
      t.integer :score
      t.integer :duration
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
