class CreateTranscripts < ActiveRecord::Migration[8.0]
  def change
    create_table :transcripts do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :content
      t.string :speaker
      t.string :sentiment
      t.float :confidence
      t.float :timestamp

      t.timestamps
    end
  end
end
