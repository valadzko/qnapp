require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :answers }
  it { should have_many :questions }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user) }

  describe '#author_of?(question)' do
    it 'user is author of question' do
      expect(user.author_of?(question)).to be true
    end

    it 'user is NOT author of question' do
      not_author = create(:user)
      expect(not_author.author_of?(question)).to be false
    end
  end

  describe '.find_for_oauth' do
    let!(:user){ create(:user) }
    let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456' ) }

    context 'user already has authorization' do
      it 'returns existing user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
       end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email } ) }
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'create new authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: "not_in_database@email.com" } ) }

        it 'creates new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'created new authorization with right values' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.build_by_omniauth_params' do
    let(:auth){ OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', user_password: '12345678') }

    context "user exists" do
      let(:user){ create(:user, email: 'test@test.com') }
      it 'find existing user by email' do
        expect(User.build_by_omniauth_params(user.email, auth)).to eq user
      end

      it 'create authorization for user' do
        user_authorization = User.build_by_omniauth_params(user.email, auth).authorizations.first
        expect(user_authorization.uid).to eq '123456'
        expect(user_authorization.provider).to eq 'twitter'
      end
    end

    context "user does not exist" do
      it 'create new user' do
        expect{ User.build_by_omniauth_params('new-email@test.com', auth) }.to change(User, :count).by(1)
      end

      it 'create authorization for new user' do
        user_authorization = User.build_by_omniauth_params(user.email, auth).authorizations.first
        expect(user_authorization).to be_a(Authorization)
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 3) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
