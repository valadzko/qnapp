require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an anthenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }
  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Question test body'
    click_on 'Post Your Question'
    expect(page).to have_content 'Question test body'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
