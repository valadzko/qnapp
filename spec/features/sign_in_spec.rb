require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  scenario 'Registered user tries to sign in' do
    visit questions_path
    expect(page).to have_selector(:link_or_button, 'Sign in')
    sign_in create(:user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end

end
