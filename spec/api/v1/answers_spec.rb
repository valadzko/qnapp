require 'rails_helper'

describe "Answers API" do
  let!(:question) { create(:question) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer){ answers.last }
      let!(:comments){ create_list(:comment, 2, commentable: answer) }
      let!(:attachments){ create_list(:attachment, 2, attachable: answer) }

      context 'question exist' do
        before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

        it_behaves_like "API Response Success"

        it 'returns list of answers' do
          expect(response.body).to have_json_size(answers.size)
        end

        %w(id created_at updated_at body).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
          end
        end

        let(:comments_path) { "0/comments" }
        it_behaves_like "API Response Object Has Comments"

        let(:attachments_path) { "0/attachments" }
        it_behaves_like "API Response Object Has Attachments"

      end

      context 'question does not exist' do
        it 'return 404 status' do
          get "/api/v1/questions/123/answers", params: { format: :json, access_token: access_token.token }
          expect(response).to be_not_found
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token){ create(:access_token) }

      context 'answer exists' do
        let!(:answer) { create(:answer) }
        let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
        let!(:comments) { create_list(:comment, 2, commentable: answer) }

        before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

        it_behaves_like "API Response Success"

        %w(id created_at updated_at body).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end

        let(:comments_path) { "comments" }
        it_behaves_like "API Response Object Has Comments"

        let!(:attachments_path){ "attachments" }
        it_behaves_like "API Response Object Has Attachments"

      end

      context 'answer does not exists' do
        it 'return 404 status' do
          get "/api/v1/answers/123", params: { format: :json, access_token: access_token.token }
          expect(response).to be_not_found
        end
      end
    end

    def do_request(options = {})
      answer = create(:answer)
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      context "question exists" do
        context "with valid attributes" do
          before { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }

          it 'saved new answer in database' do
            expect{ post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }}.to change(Answer, :count).by(1)
          end

          it_behaves_like "API Response Success"

          it 'return answer with new body' do
            new_answer_body = "this is new answer body!"
            post "/api/v1/questions/#{question.id}/answers", params: { answer: {body: new_answer_body}, format: :json, access_token: access_token.token }
            expect(response.body).to be_json_eql(new_answer_body.to_json).at_path("body")
          end
        end

        context "with invalid attributes" do
          before { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }

          it_behaves_like "API Failed To Create Object"

          it 'does not save invalid answer in database' do
            expect{ post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }.to_not change(Answer, :count)
          end
        end

      end
    end
    def do_request(options = {})
      question = create(:question)
      post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json }.merge(options)
    end
  end
end
