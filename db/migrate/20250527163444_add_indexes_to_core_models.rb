class AddIndexesToCoreModels < ActiveRecord::Migration[8.0]
  def change
    # Performance indexes for common queries
    add_index :leads, [:status, :score]
    add_index :leads, [:qualified, :created_at]
    add_index :leads, :source
    
    add_index :conversations, [:created_at, :status]
    add_index :conversations, [:assistant_id, :status]
    add_index :conversations, :score
    
    add_index :transcripts, [:conversation_id, :speaker]
    add_index :transcripts, :sentiment
    
    add_index :appointments, [:scheduled_at, :status]
    add_index :appointments, [:lead_id, :status]
    
    add_index :assistants, [:user_id, :active]
    add_index :assistants, :language
    
    # Basic text search indexes
    add_index :leads, :name
    add_index :leads, :email
  end
end
