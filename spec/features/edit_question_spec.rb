require_relative 'features_helper'

feature 'Edit question', %q{
  In order to correct mistake in question
  As author of the question
  I want to be able to edit my question
} do

  given!(:author){ create(:user) }
  given!(:question) {create(:question, user: author)}
  scenario 'Author can edit his question' do
    sign_in(author)
    visit question_path(question)
    click_on 'edit' # same as expect(page).to have_link 'Edit'
    edited_title = question.title + 'title_appendix'
    edited_body = question.body + 'body_appendix'
    fill_in 'question_title', with: edited_title
    fill_in 'question_body', with: edited_body
    click_on 'Update Question'
# TODO:
#    within ('.question') do
    expect(page).to have_content edited_title
    expect(page).to have_content edited_body
#    end
  end

  scenario 'Authenticated non-author can not edit the question' do
    non_author = create(:user)
    sign_in(non_author)
    visit question_path(question)
    expect(page).to_not have_link 'edit'
  end

  scenario 'Non-authenticated user can not edit the question' do
    visit question_path(question)
    expect(page).to_not have_link 'edit'
  end



end
