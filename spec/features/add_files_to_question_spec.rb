require_relative 'features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As author of question
  I want to attach files to question
} do

  given(:user){ create(:user) }
  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User add file when create question' do
    fill_in 'question_title', with: 'Test question title'
    fill_in 'question_body', with: 'Question test body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
