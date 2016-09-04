require_relative 'features_helper'

feature 'Delete question', %q{
  In order to don't be ashamed for asked question
  As an authenticated user who posted this question
  I want to be able to delete my question
} do

  given!(:user) { create(:user) }
  before(:each) do
    sign_in(user)
    @question = create(:question, user: user)
  end

  scenario 'Autheticated user who asked the question delete it' do
    visit question_path(@question)
    click_on 'Delete question'
    expect(page).to have_current_path(questions_path)
    expect(page).to_not have_content @question.title
  end

  scenario 'Authenticated user can not delete question asked by other user' do
    sign_out
    sign_in(create(:user))
    visit question_path(@question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user can not see the Delete question link' do
    sign_out
    visit question_path(@question)
    expect(page).to_not have_link 'Delete question'
  end
end
