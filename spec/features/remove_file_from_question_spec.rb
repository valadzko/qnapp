require_relative 'features_helper'

feature 'Remove files from question', %q{
  In order to edit my attachments in question
  As author of question
  I want to be able to remove attachment file from my question
} do
  given(:author){ create(:user) }
  given(:question){ create(:question, user: author) }
  given!(:file) { create(:attachment, attachable: question) }

  scenario 'Author can remove attachment from question', js: true do
    sign_in(author)
    visit question_path(question)
    expect(page).to have_content 'spec_helper.rb'
    click_on 'edit'
    click_on 'remove file'
    click_on 'Save'
    expect(page).to_not have_content 'spec_helper.rb'
  end

  scenario 'Non author can not remove file', js: true do
    sign_in(create(:user))
    visit question_path(question)
    expect(page).to have_content 'spec_helper.rb'
    expect(page).to_not have_link 'edit'
  end

  scenario 'Non authenticated user can not delete question file', js: true do
    visit question_path(question)
    expect(page).to have_content 'spec_helper.rb'
    expect(page).to_not have_link 'edit'
  end
end
