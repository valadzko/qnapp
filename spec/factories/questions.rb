FactoryGirl.define do
  factory :question do

    body "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    title "MyString"
  end

  factory :invalid_question, class: "Question" do
    body nil
    title nil
  end
end
