class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :company
      t.string :source
      t.string :status
      t.integer :score
      t.boolean :qualified
      t.jsonb :metadata
      t.references :assistant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
