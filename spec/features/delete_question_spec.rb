require 'rails_helper'

feature 'Delete question', %q{
  In order to don't be ashemed for asked question
  As an authenticated user who posted this question
  I want to be able to delete my question
} do

  given(:user) { create(:user) }
  scenario 'Autheticated user who asked the question delete it' do
    # sign_in(user)
    # visit questions_path
    # click_on 'Ask question'
    # fill_in 'question_title', with: 'Test question title'
    # fill_in 'question_body', with: 'Question test body'
    # click_on 'Post Your Question'
    # expect(page).to have_content 'Delete question'
    # click_on 'Delete question'
    # visit questions_path
    # expect(page).to_not have_content 'Test question title'
  end

  scenario 'Authenticated user can not delete question aked by other user' do
  #   question_creator = create(:user)
  #   not_a_question_creator = create(:user)
  #   sign_in(question_creator)
  #   visit questions_path
  #   click_on 'Ask question'
  #   fill_in 'question_title', with: 'Test question title'
  #   fill_in 'question_body', with: 'Question test body'
  #   click_on 'Post Your Question'
  #   sign_out
  #   sign_in(not_a_question_creator)
  #   visit questions_path
  #   click_on 'Test question title'
  #   expect(page).to have_content 'Test question title'
  #   expect(page).to_not have_content 'Delete question'
  # #  visit questions_path
  # #  click_on 'Ask question'
  end

end
