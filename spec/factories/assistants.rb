FactoryBot.define do
  factory :assistant do
    name { "MyString" }
    tone { "MyString" }
    role { "MyString" }
    script { "MyText" }
    voice_id { "MyString" }
    language { "MyString" }
    active { false }
    user { nil }
  end
end
