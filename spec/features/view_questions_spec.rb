require 'rails_helper'

feature 'View questions', %q{
  In order to get help from community
  As an any user
  I want to see the list of existing questions
} do

  scenario 'User can see the list of questions' do
    q1, q2 = create_list(:question, 2)
    visit questions_path
    expect(page).to have_content q1.title
    expect(page).to have_content q2.title
  end
end
