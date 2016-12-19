require_relative 'features_helper'

feature 'Auth with Twitter', %q{
  In order to authenticate with twitter
  As twitter account owner
  I want to be able to use twitter for registration and login
}do

  describe "Authentication with Twitter" do
    before(:each) do
      OmniAuth.config.mock_auth[:twitter] = nil
    end

    scenario "registered user sign in with twitter" do
      user = create(:user)
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Provide your email'
      fill_in 'Email', with: user.email
      click_on 'Continue'

      expect(page).to have_content "Successfully authenticated from Twitter account"
      expect(current_path).to eq root_path
    end

    scenario "non registered user sign in with twitter" do
      clear_emails
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'
      email = "test@email.com"

      expect(page).to have_content 'Provide your email'
      fill_in 'Email', with: email
      click_on 'Continue'

      open_email(email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      click_on 'Sign in with Twitter'

      expect(page).to have_content "Successfully authenticated from Twitter account"
      expect(current_path).to eq root_path
    end

    scenario "Authenticated user sign out" do
      user = create(:user)
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Provide your email'
      fill_in 'Email', with: user.email
      click_on 'Continue'
      expect(page).to have_content "Successfully authenticated from Twitter account"

      click_on 'Sign out'
      expect(page).to have_content 'Signed out successfully'
      expect(current_path).to eq root_path
    end
  end
end
