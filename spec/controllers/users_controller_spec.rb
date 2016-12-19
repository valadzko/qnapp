require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST#require_email_for_auth" do
    before(:each) do
      session['devise.omiauth.auth'] = {
        "provider" => 'twitter',
        "uid" => '12345',
        "user_password" => '0123456789'
      }
    end
    context "user has been authorized already" do
      it 'does not increase user count' do
        user = create(:user)
        expect{ post :require_email_for_auth, params: { user: {email: user.email} } }.to_not change { User.count }
      end
    end
    context "user has no authorization previously" do
      it 'create new user' do
        user = build(:user, email: '', password: '12345678', password_confirmation: '12345678' )
        expect{ post :require_email_for_auth, params: { user: {email: 'new-email@qnapp.com'} } }.to change { User.count }.by(1)
      end
    end
  end
end
