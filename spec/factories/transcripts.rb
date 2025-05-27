FactoryBot.define do
  factory :transcript do
    conversation { nil }
    content { "MyText" }
    speaker { "MyString" }
    sentiment { "MyString" }
    confidence { 1.5 }
    timestamp { 1.5 }
  end
end
