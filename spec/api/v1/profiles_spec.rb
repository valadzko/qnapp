require 'rails_helper'

describe "Profile API" do
  describe "GET /me" do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me){ create(:user) }
      let(:access_token){ create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #users' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me){ create(:user) }
      let!(:users_list){ create_list(:user, 3) }
      let(:access_token){ create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/all', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end
      it 'returns right number of existing users' do
        expect(JSON.parse(response.body).count).to eq 3
      end
      it 'does not return current_user' do
        expect(response.body).to_not include_json(me.to_json)
      end
      it 'return users' do
        expect(response.body).to be_json_eql(users_list.to_json)
      end

      %w(password encrypted_password).each do |attr|
        it "users do not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end      
    end
  end
end
