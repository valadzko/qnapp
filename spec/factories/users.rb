FactoryGirl.define do
  sequence :email do |n|
    "user#{n}test@test.ru"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.now.utc
  end

  factory :unconfirmed_user, class: "User" do
    email
    password '12345678'
    password_confirmation '12345678'
  end
end
