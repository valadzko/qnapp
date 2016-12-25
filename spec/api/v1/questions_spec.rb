require 'rails_helper'

describe "Questions API" do
  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:questions){ create_list(:question, 2) }
      let!(:question){ questions.first }
      let!(:comments){ create_list(:comment, 2, commentable: question) }
      let!(:attachments){ create_list(:attachment, 2, attachable: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "API Response Success"

      it 'returns list of questions' do
        expect(response.body).to have_json_size(questions.size)
      end

      %w(id created_at title updated_at body).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      let(:comments_path) { "0/comments" }
      it_behaves_like "API Response Object Has Comments"

      let(:attachments_path) { "0/attachments" }
      it_behaves_like "API Response Object Has Attachments"

    end
    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token){ create(:access_token) }

      context 'question exists in database' do
        let!(:question) { create(:question) }
        let!(:attachments) { create_list(:attachment, 2, attachable: question) }
        let!(:comments) { create_list(:comment, 2, commentable: question) }
        let(:comment) { comments.first }

        before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

        it_behaves_like "API Response Success"

        %w(id created_at updated_at title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end

        let(:comments_path) { "comments" }
        it_behaves_like "API Response Object Has Comments"

        let!(:attachments_path){"attachments"}
        it_behaves_like "API Response Object Has Attachments"
      end

      context 'question does not exist' do
        it 'return 404 status' do
          get "/api/v1/questions/123", params: { format: :json, access_token: access_token.token }
          expect(response).to be_not_found
        end
      end
    end

    def do_request(options = {})
      question = create(:question)
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      context 'with valid question params' do

        before { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }

        it_behaves_like "API Response Success"

        it 'saves the question in database' do
          expect{post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }}.to change(Question, :count).by(1)
        end

        it 'return question json with new body' do
          new_question_body = "This is new question body!"
          post '/api/v1/questions', params: { question: attributes_for(:question, body: new_question_body), format: :json, access_token: access_token.token }
          expect(response.body).to be_json_eql(new_question_body.to_json).at_path("body")
        end
      end

      context 'with invalid question params' do

        before { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }

        it_behaves_like "API Failed To Create Object"

        it 'does not save question to database' do
          expect{ post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }}.to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", params: { question: attributes_for(:question), format: :json }.merge(options)
    end
  end
end
