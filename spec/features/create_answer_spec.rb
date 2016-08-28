require 'rails_helper'

feature 'Create Answer on question', %q{
  In order to share my brilliant knowledge and experience
  As authenticated user
  I want to be able to create answer on the question
}do
  given(:question) { create(:question) }
  scenario 'Authenticated user can create answer for the question' do
    sign_in create(:user)
    visit question_path(question)
    fill_in 'answer_body', with: 'The answer text which is worth to type'
    click_on 'Post Your Answer'
    expect_page_to_have_question(question)
    expect(page).to have_content 'The answer text which is worth to type'
  end

  scenario 'Non-authenticated user can not create answer on the question'do
    visit question_path(question)
    expect(page).to_not have_link 'Post Your Answer'
  end
end
