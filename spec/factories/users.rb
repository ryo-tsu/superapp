FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }

    trait :admin do
      admin { true }
    end

    trait :activated do
      atcivated { true }
      activated_at { Time.zone.now }
    end
  end
end
