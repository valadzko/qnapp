require_relative 'features_helper'

feature 'User vote for question', %q{
  In order to show the importance of question
  As authenticated user
  I want to upvote and down vote question
} do

  given!(:user){ create(:user) }
  given!(:question){ create(:question, user: user) }

  scenario 'Unauthenticated user can see the question rating' do
    visit question_path(question)
    expect(page).to have_content 'Rating: 0'
  end

  scenario 'Author can not vote up and vote down for his own question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'upvote'
    expect(page).to_not have_link 'reset'
    expect(page).to_not have_link 'downvote'
  end

  scenario 'Non authenticated user can not vote' do
    visit question_path(question)
    expect(page).to_not have_link 'upvote'
    expect(page).to_not have_link 'reset'
    expect(page).to_not have_link 'downvote'
  end

  scenario 'Authenticated user can vote up answer', js: true do
    sign_in(create(:user))
    visit question_path(question)
    click_on 'upvote'
    expect(page).to have_content 'Rating: 1'
    click_on 'reset'
    expect(page).to have_content 'Rating: 0'
  end

  scenario 'Authenticated user can vote down answer', js: true do
    sign_in(create(:user))
    visit question_path(question)
    click_on 'downvote'
    expect(page).to have_content 'Rating: -1'
    click_on 'reset'
    expect(page).to have_content 'Rating: 0'
  end
end
