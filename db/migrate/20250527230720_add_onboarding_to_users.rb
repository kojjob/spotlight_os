class AddOnboardingToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :onboarding_completed, :boolean
    add_column :users, :onboarding_step, :integer
    add_column :users, :onboarding_completed_at, :datetime
  end
end
