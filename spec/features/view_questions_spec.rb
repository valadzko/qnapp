require 'rails_helper'

feature 'View questions', %q{
  In order to get help from community
  As an any user
  I want to see the list of existing questions
} do

  scenario 'User can see the list of questions' do
    Question.create(title: "How far can you walk into the woods?", body: "some questions body")
    Question.create(title: "What has a head and a tail but no body?", body: "some question body 2")
    visit questions_path
    expect(page).to have_content 'How far can you walk into the woods?'
    expect(page).to have_content 'What has a head and a tail but no body?'
  end
end
