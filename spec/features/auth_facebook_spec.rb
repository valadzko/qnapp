require_relative 'features_helper'

feature 'Auth with Facebook', %q{
  In order to authenticate with facebook
  As facebook account owner
  I want to be able to use facebook for registration and login
}do

  describe "Authentication with Facebook" do
    before(:each) do
      OmniAuth.config.mock_auth[:facebook] = nil
    end
    scenario "registered user sign in with facebook" do
      user = create(:user)
      visit new_user_registration_path
      OmniAuth.config.add_mock(:facebook, {info: { email: user.email }})
      click_on 'Sign in with Facebook'
      expect(page).to have_content "Successfully authenticated from Facebook account"
      expect(current_path).to eq root_path
    end

    scenario "non registered user sign in with facebook" do
      clear_emails
      email = "test@email.com"
      visit new_user_registration_path
      OmniAuth.config.add_mock(:facebook, {info: { email: email }})

      click_on 'Sign in with Facebook'

      open_email(email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      click_on 'Sign in with Facebook'

      expect(page).to have_content "Successfully authenticated from Facebook account"
      expect(current_path).to eq root_path
    end

    scenario "Authenticated user sign out" do
      user = create(:user)
      visit new_user_registration_path
      OmniAuth.config.add_mock(:facebook, {info: { email: user.email }})
      click_on 'Sign in with Facebook'
      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully'
      expect(current_path).to eq root_path
    end
  end
end
