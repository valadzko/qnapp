FactoryGirl.define do
  sequence :body do |n|
    "The answer on your question is somewhere else. Did you mean the number #{n}?"
  end

  factory :answer do
    body 
    question
    user
  end

  factory :invalid_answer, class: Answer do
    body nil
    question nil
  end
end
