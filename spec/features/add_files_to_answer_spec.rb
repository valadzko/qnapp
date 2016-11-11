require_relative 'features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As author of answer
  I want to attach files to answer
} do

  given(:user){ create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add file when create question', js: true do
    fill_in 'answer_body', with: 'The answer text which is worth to type'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Answer'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
