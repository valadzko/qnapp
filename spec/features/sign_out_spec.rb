require 'rails_helper'

feature 'User can sign out', %q{
  In order to use the site on public computers
  As signed-in user
  I want to sign out
} do

  given(:user) { create(:user) }
  scenario 'Signed-in tries to sign out' do
    sign_in(user)
    visit questions_path
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(page).to_not have_selector(:link_or_button, 'Sign in')
    expect(page).to_not have_selector(:link_or_button, 'Sign up')
    click_on 'Sign out'
    expect(page).to have_content("Signed out successfully.")
    expect(page).to_not have_selector(:link_or_button, 'Sign out')
    expect(page).to have_selector(:link_or_button, 'Sign in')
    expect(page).to have_selector(:link_or_button, 'Sign up')

  end


end
