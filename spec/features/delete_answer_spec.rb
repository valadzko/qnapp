require_relative 'features_helper'

feature 'Delete answer', %q{
  In order to don't be ashamed for your answer
  As as author of answer
  I want to be able to delete my answer
} do

  given!(:user) { create(:user) }
  before(:each) do
    sign_in(user)
    @question = create(:question, user: user)
    @answer = create(:answer, question: @question, user: user)
  end

  scenario 'Author of answer delete answer on his question', js: true do
    visit question_path(@question)
    click_on 'Delete answer'
    expect(page).to have_current_path(question_path(@question))
    expect(page).to_not have_content(@answer.body)
  end

  scenario 'Non-author can not delete answer', js: true do
    sign_out
    sign_in(create(:user))
    visit question_path(@question)
    expect(page).to_not have_link 'Delete Answer'
  end
end
