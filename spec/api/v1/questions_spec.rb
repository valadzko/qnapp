require 'rails_helper'

describe "Questions API" do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        get '/api/v1/questions', params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:questions){ create_list(:question, 2) }
      let!(:question){ questions.first }
      let!(:comments){ create_list(:comment, 2, commentable: question) }
      let!(:attachments){ create_list(:attachment, 2, attachable: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(questions.size)
      end

      %w(id created_at title updated_at body).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context "comments in question" do
        let(:comment){ comments.first }

        it 'included comment list in question' do
          expect(response.body).to have_json_size(comments.size).at_path("0/comments")
        end

        %w(id content created_at commentable_type commentable_id).each do |attr|
          it "comment object in question contains #{attr} param" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("0/comments/0/#{attr}")
          end
        end

        it 'comment in question includes user_email param' do
          expect(response.body).to be_json_eql(comment.user.email.to_json).at_path("0/comments/0/user_email")
        end
      end

      context "attachments in question" do
        let!(:attachment) { attachments.last }

        it 'included attachment list in question' do
          expect(response.body).to have_json_size(attachments.size).at_path("0/attachments")
        end

        %w(id created_at).each do |attr|
          it "attachment object in question contains #{attr} param" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("0/attachments/0/#{attr}")
          end
        end

        it 'attachment in question includes url param' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("0/attachments/0/url")
        end
      end
    end
  end

  describe 'GET /show' do

    context 'unauthorized' do
      let!(:question){ create(:question) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }

      context 'question exists in database' do
        let!(:question) { create(:question) }
        let!(:attachments) { create_list(:attachment, 2, attachable: question) }
        let!(:comments) { create_list(:comment, 2, commentable: question) }
        let(:comment) { comments.first }

        before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

        it 'returns status 200' do
          expect(response).to be_success
        end

        %w(id created_at updated_at title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end

        context "comments in question" do
          let(:comment){ comments.first }

          it 'included comment list in question' do
            expect(response.body).to have_json_size(comments.size).at_path("comments")
          end

          %w(id content created_at commentable_type commentable_id).each do |attr|
            it "comment object in question contains #{attr} param" do
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
            end
          end

          it 'comment in question includes user_email param' do
            expect(response.body).to be_json_eql(comment.user.email.to_json).at_path("comments/0/user_email")
          end
        end

        context "attachments in question" do
          let(:attachment) { attachments.last }

          it 'included attachment list in question' do
            expect(response.body).to have_json_size(attachments.size).at_path("attachments")
          end

          %w(id created_at).each do |attr|
            it "attachment object in question contains #{attr} param" do
              expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
            end
          end

          it 'attachment in question includes url param' do
            expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
          end
        end

      end
      context 'question does not exist' do
        it 'return 404 status' do
          get "/api/v1/questions/123", params: { format: :json, access_token: access_token.token }
          expect(response).to be_not_found
        end
      end

    end

  end

  describe 'POST /create' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      context 'with valid question params' do

        it 'returns status 200' do
          post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(response).to be_success
        end

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
        it 'return 422 (unprocessable entity) code' do
          post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'has errors in response' do
          post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.body).to have_json_path("errors")
        end

        it 'does not save question to database' do
          expect{ post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }}.to_not change(Question, :count)
        end
      end
    end

  end
end
