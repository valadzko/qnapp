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

  scenario 'Authenticated user can vote up answer'
  scenario 'Author can not vote up and vote down for his own answer'
  scenario 'Authenticated user can down vote answer'
  scenario 'User can vote up again and it cancel answer up vote'
  scenario 'User can vote up again and it cancel answer up vote'
  scenario 'Non authenticated user can not up vote answer'
  scenario 'Non authenticated user can not down vote answer'

end
