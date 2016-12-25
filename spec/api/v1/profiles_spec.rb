require 'rails_helper'

describe "Profile API" do
  describe "GET /me" do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me){ create(:user) }
      let(:access_token){ create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "API Response Success"

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
    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #users' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me){ create(:user) }
      let!(:users_list){ create_list(:user, 3) }
      let(:access_token){ create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/all', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "API Response Success"

      it 'returns right number of existing users' do
        expect(response.body).to have_json_size(users_list.size)
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
    def do_request(options = {})
      get '/api/v1/profiles/all', params: { format: :json }.merge(options)
    end
  end
end
