FactoryGirl.define do

  factory :sign_in_record do
    first_name          nil
    last_name           nil
    room                nil
    sign_in_time        nil
    newcomer            false
    label               nil
  end

  factory :default_sign_in_record, parent: :sign_in_record do
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    room          { "#{['Blue','Green','Orange','Purple','Pink'][rand(5)]} room" }
    sign_in_time  { DateTime.now.change(:sec => 0) }
    label         { "%s%03d" % [('A'..'Z').to_a[rand(26)], Faker::Number.between(1, 100)] }
  end

  factory :newcomer_sign_in_record, parent: :default_sign_in_record do
    newcomer true
  end


end
