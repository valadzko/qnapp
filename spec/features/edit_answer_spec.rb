require_relative 'features_helper'

feature 'Edit answer', %q{
  In order to correct mistake in answer
  As author of this answer
  I want to be able to edit my answer
} do

  given(:user){ create(:user) }
  given!(:question){ create(:question) }
  given!(:answer){ create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)
    within '.answer#' + "answer-#{answer.id}" do
      expect(page).to_not have_link 'edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Author sees link to Edit answer' do
      within '.answer#' + "answer-#{answer.id}" do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'Author tries to edit his answer', js: true do
      click_on 'edit'
      within '.answers' do
        fill_in 'answer_body', with: 'New edited answer text'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'New edited answer text'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Authenticated user tries to edit other\'s answer', js: true do
      sign_out
      other_user = create(:user)
      answer2 = create(:answer, question: question, user: other_user)
      sign_in(other_user)
      visit question_path(question)
      within '.answer#' + "answer-#{answer.id}" do
        expect(page).to_not have_link 'edit'
      end
      # just to be sure that we can edit our answer on the same page
      within '.answer#' + "answer-#{answer2.id}" do
        expect(page).to have_link 'edit'
      end
    end
  end
end
