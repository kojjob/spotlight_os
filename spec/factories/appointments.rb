FactoryBot.define do
  factory :appointment do
    lead { nil }
    assistant { nil }
    scheduled_at { "2025-05-27 17:28:27" }
    duration { 1 }
    status { "MyString" }
    external_id { "MyString" }
    external_link { "MyString" }
    metadata { "" }
  end
end
