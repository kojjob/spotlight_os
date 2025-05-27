FactoryBot.define do
  factory :lead do
    name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    company { "MyString" }
    source { "MyString" }
    status { "MyString" }
    score { 1 }
    qualified { false }
    metadata { "" }
    assistant { nil }
  end
end
