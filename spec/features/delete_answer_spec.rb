require 'rails_helper'

feature 'Delete answer', %q{
  In order to don't be ashamed for your answer
  As as author of answer
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  scenario 'Author of answer delete answer on his question' do
    sign_in(user)
    question = create(:question, user: user)
    visit question_path(question)
    click_on 'Add new answer'
    fill_in 'answer_body', with: 'The answer text which is worth to type'
    click_on 'Post Your Answer'
    expect(page).to have_content 'Delete answer'
    click_on 'Delete answer'
    expect(page).to have_current_path(question_path(question))
    expect(page).to_not have_content("The answer text which is worth to type")
  end

  scenario 'Author of answer delete answer on question of other user' do
    sign_in(user)
    non_question_creator = create(:user)
    question = create(:question, user: user)
    sign_out
    sign_in(non_question_creator)
    visit question_path(question)
    click_on 'Add new answer'
    fill_in 'answer_body', with: 'The answer text which is worth to type'
    click_on 'Post Your Answer'
    expect(page).to have_content 'Delete answer'
    click_on 'Delete answer'
    expect(page).to have_current_path(question_path(question))
    expect(page).to_not have_content("The answer text which is worth to type")
  end

  scenario 'Non-author can not delete answer' do
    user = create(:user)
    sign_in(user)
    question = create(:question, user: user)
    answer = create(:answer,question: question, user: user)
    sign_out
    non_answer_author = create(:user)
    sign_in(non_answer_author)
    visit question_path(question)
    expect(page).to_not have_content 'Delete Answer'
  end
end
