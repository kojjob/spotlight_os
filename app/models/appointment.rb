class Appointment < ApplicationRecord
  belongs_to :lead
  belongs_to :assistant
end
