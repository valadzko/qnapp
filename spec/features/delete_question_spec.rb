require 'rails_helper'

feature 'Delete question', %q{
  In order to don't be ashamed for asked question
  As an authenticated user who posted this question
  I want to be able to delete my question
} do

  given(:user) { create(:user) }
  scenario 'Autheticated user who asked the question delete it' do
    sign_in(user)
    question = create(:question, user: user)
    visit question_path(question)
    expect(page).to have_content 'Delete question'
    click_on 'Delete question'
    expect(page).to have_current_path(questions_path)
  end

  scenario 'Authenticated user can not delete question asked by other user' do
    other_user = create(:user)
    other_user_question = create(:question, user: other_user)
    sign_in(user)
    visit question_path(other_user_question)
    expect(page).to_not have_content 'Delete question'
  end
end
