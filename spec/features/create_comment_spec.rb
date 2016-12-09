require_relative 'features_helper'

feature 'Create Comment for question', %q{
  To add something to question or answer
  As authenticated user
  I want to be able to comment question and answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user can create comment for the question', js: true do
    sign_in create(:user)
    visit question_path(question)
    fill_in 'comment_content', with: 'My comment message'
    click_on 'Add comment'
    expect(page).to have_content 'My comment message'
  end

  scenario 'User can see new comment in different session', js: true do
    Capybara.using_session('user') do
      sign_in create(:user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'comment_content', with: 'My comment message'
      click_on 'Add comment'
      expect(page).to have_content 'My comment message'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'My comment message'
    end
  end
end
