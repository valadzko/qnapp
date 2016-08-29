FactoryGirl.define do
  sequence :title do |n|
    "How do you spell number #{n} ?"
  end

  factory :question do
    body "There is no way I can spell your number. But you are welcome!"
    title
    user
  end

  factory :invalid_question, class: "Question" do
    body nil
    title nil
  end
end
