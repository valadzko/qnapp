require_relative 'features_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an anthenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  context 'single session' do
    scenario 'Authenticated user creates question' do
      sign_in user

      visit questions_path
      click_on 'Ask question'
      fill_in 'question_title', with: 'Test question title'
      fill_in 'question_body', with: 'Question test body'
      click_on 'Post Your Question'
      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Question test body'
    end

    scenario 'Non-authenticated user tries to create question' do
      visit questions_path
      expect(page).to_not have_content 'Ask question'
    end
  end

  xcontext "miltiple sessions" do
    scenario 'new question appears in another user session', js: true do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'question_title', with: 'Test question title'
        fill_in 'question_body', with: 'Question test body'
        click_on 'Post Your Question'
        expect(page).to have_content 'Test question title'
        expect(page).to have_content 'Question test body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question title'
      end
    end
  end
end
