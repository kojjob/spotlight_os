FactoryBot.define do
  factory :conversation do
    lead { nil }
    assistant { nil }
    source { "MyString" }
    status { "MyString" }
    score { 1 }
    duration { 1 }
    started_at { "2025-05-27 17:28:14" }
    ended_at { "2025-05-27 17:28:14" }
  end
end
