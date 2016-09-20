require_relative 'features_helper'

feature 'User sign up', %q{
  In order to be able to use features that requires authentication
  As unregistered user
  I want to be able to sign up
} do

  before do
    visit root_path
    within '.header' do
      click_on 'Sign up'
    end
  end

  scenario 'Unregistered user tries to sign up and succeed' do
    fill_in 'user_email', with: 'my-test-email@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    within '.content' do
      click_on 'Sign up'
    end
    expect(page).to have_content "You have signed up successfully."
  end

  scenario 'Unregistered user tries to sign up, but passwords are not match' do
    fill_in 'user_email', with: 'my-test-email@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: 'password-does-not-match'
    within '.content' do
      click_on 'Sign up'
    end
    expect(page).to have_content "Password confirmation doesn't match"
  end

  scenario 'Unregistered user tries to sign up, but email is already used' do
    fill_in 'user_email', with: create(:user).email # to have already used email
    fill_in 'user_password', with: '11111111'
    fill_in 'user_password_confirmation', with: '11111111'
    within '.content' do
      click_on 'Sign up'
    end
    expect(page).to have_content "Email has already been taken"
  end

end
