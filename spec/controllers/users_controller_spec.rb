require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST#require_email_for_auth" do
      it 'create authorization for user' do
        session['omniauth.data'] = {
          "provider" => 'twitter',
          "uid" => '12345',
          "user_password" => '0123456789'
        }
        user = build(:user, email: '', password: '12345678', password_confirmation: '12345678' )
        expect{ post :require_email_for_auth, params: { user: {email: 'new-email@qnapp.com'} } }.to change { User.count }.by(1)
      end
    end
end
