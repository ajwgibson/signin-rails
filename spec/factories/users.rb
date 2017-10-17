FactoryGirl.define do

  factory :user do
    email                 nil
    password              nil
    password_confirmation nil
    first_name            nil
    last_name             nil
  end

  factory :default_user, parent: :user do
    email                 { Faker::Internet.email }
    password              "password"
    password_confirmation "password"
    first_name            Faker::Name.first_name
    last_name             Faker::Name.last_name
  end

  factory :administrator, parent: :default_user do
    admin  true
  end

end
