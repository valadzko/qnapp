require_relative 'features_helper'

feature 'User vote for question', %q{
  In order to show the importance of question
  As authenticated user
  I want to upvote and down vote question
} do

  scenario 'Unauthenticated user can see the question rating' do

  end

  scenario 'Authenticated user can vote up question'
  scenario 'Author can not vote up and vote down for his own question'
  scenario 'Authenticated user can down vote question'
  scenario 'User can vote up again and it cancel question up vote'
  scenario 'User can vote up again and it cancel question up vote'
  scenario 'Non authenticated user can not up vote question'
  scenario 'Non authenticated user can not down vote question'

end
