class CreateAssistants < ActiveRecord::Migration[8.0]
  def change
    create_table :assistants do |t|
      t.string :name
      t.string :tone
      t.string :role
      t.text :script
      t.string :voice_id
      t.string :language
      t.boolean :active
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
