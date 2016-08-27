require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to use features that requires authentication
  As unregistered user
  I want to be able to sign up
} do

  scenario 'Unregistered user tries to sign up and succeed' do
    visit questions_path
    expect(page).to have_selector(:link_or_button, 'Sign up')
    click_on 'Sign up'
    fill_in 'user_email', with: 'my-test-email@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content "You have signed up successfully."
  end

  scenario 'Unregistered user tries to sign up, but passwords are not match' do
    visit questions_path
    click_on 'Sign up'
    fill_in 'user_email', with: 'my-test-email@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: 'password-does-not-match'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match"
  end

  scenario 'Unregistered user tries to sign up, but email is already used' do
    visit questions_path
    click_on 'Sign up'
    fill_in 'user_email', with: create(:user).email # to have already used email
    fill_in 'user_password', with: '11111111'
    fill_in 'user_password_confirmation', with: '11111111'
    click_on 'Sign up'
    expect(page).to have_content "Email has already been taken"
  end

end
