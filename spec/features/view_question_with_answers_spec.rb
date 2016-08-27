require 'rails_helper'

feature 'View question and answers', %q{
  In order to view the whole question and existing answers to it,
  As any user
  I want to be able to see the question details view with answers
} do

  given(:question) {create(:question)}
  scenario 'Any user can see detailed question view with answers' do
    answer = create(:answer, question: question)
    visit question_path(question)
    expect_page_to_have_question(question)
    expect(page).to have_content answer.body
  end

  scenario 'Any user can see details question view with no answers' do
    visit question_path(question)
    expect_page_to_have_question(question)
    expect(page).to have_content 'No answers'
  end

end
