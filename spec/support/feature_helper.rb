module FeatureHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_out
    visit destroy_user_session_path
  end

  def expect_page_to_have_question(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
