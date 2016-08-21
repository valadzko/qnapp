require 'rails_helper'

feature 'View question and answers', %q{
  In order to view the whole question and existing answers to it,
  As any user
  I want to be able to see the question details view with answers
} do

  scenario 'Any user can see detailed question view with answers' do
    @q = Question.create(title: 'Tricky question about substracting numbers', body: 'How many times can you subtract 10 from 100?')
    @q.answers.create(body: 'Once. Next time you would be subtracting 10 from 90.')

    visit question_path(@q)
    expect(page).to have_content 'Tricky question about substracting numbers'
    expect(page).to have_content 'How many times can you subtract 10 from 100?'
    expect(page).to have_content 'Once. Next time you would be subtracting 10 from 90.'
  end

  scenario 'Any user can see details question view with no answers' do
    @q = Question.create(title: 'Tricky question about substracting numbers', body: 'How many times can you subtract 10 from 100?')

    visit question_path(@q)
    expect(page).to have_content 'Tricky question about substracting numbers'
    expect(page).to have_content 'How many times can you subtract 10 from 100?'
    expect(page).to have_content 'No answers'
  end
end
