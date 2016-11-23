require_relative 'features_helper'

feature 'User vote for answer', %q{
  In order to show the importance of answer
  As authenticated user
  I want to upvote and down vote answer
} do

  given(:user){ create(:user) }
  given!(:question){ create(:question) }
  given!(:answer){ create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can see the answer rating' do
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content 'Rating: 0'
    end
  end

  scenario 'Author can not vote up and vote down for his own answer' do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'upvote'
      expect(page).to_not have_link 'downvote'
    end
  end

  scenario 'Non authenticated user can not vote' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'upvote'
      expect(page).to_not have_link 'downvote'
    end
  end

  scenario 'Authenticated user can vote up answer', js: true do
    sign_in(create(:user))
    visit question_path(question)
    within '.answers' do
      click_on 'upvote'
      expect(page).to have_content 'Rating: 1'
      click_on 'upvote'
      expect(page).to have_content 'Rating: 0'
    end
  end

  scenario 'Authenticated user can vote down answer', js: true do
    sign_in(create(:user))
    visit question_path(question)
    within '.answers' do
      click_on 'downvote'
      expect(page).to have_content 'Rating: -1'
      click_on 'downvote'
      expect(page).to have_content 'Rating: 0'
    end
  end
end
