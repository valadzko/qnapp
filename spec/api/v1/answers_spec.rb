require 'rails_helper'

describe "Answers API" do
  describe 'GET /index' do
    context 'unauthorized' do
      let!(:question) { create(:question) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        get '/api/v1/questions', params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:question){ create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer){ answers.last }
      let!(:comments){ create_list(:comment, 2, commentable: answer) }
      let!(:attachments){ create_list(:attachment, 2, attachable: answer) }

      context 'question exist' do
        before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns list of answers' do
          expect(response.body).to have_json_size(answers.size)
        end

        %w(id created_at updated_at body).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
          end
        end

        context "comments in answer" do
          let(:comment){ comments.first }

          it 'included comment list in question' do
            expect(response.body).to have_json_size(comments.size).at_path("0/comments")
          end

          %w(id content created_at commentable_type commentable_id).each do |attr|
            it "comment object in answer contains #{attr} param" do
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("0/comments/0/#{attr}")
            end
          end

          it 'comment in answer includes user_email param' do
            expect(response.body).to be_json_eql(comment.user.email.to_json).at_path("0/comments/0/user_email")
          end
        end

        context "attachments in answer" do
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

      context 'question does not exist' do
        it 'return 404 status' do
          get "/api/v1/questions/123/answers", params: { format: :json, access_token: access_token.token }
          expect(response).to be_not_found
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let!(:answer) { create(:answer) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is not valid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }

      context 'answer exists' do
        let!(:answer) { create(:answer) }
        let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
        let!(:comments) { create_list(:comment, 2, commentable: answer) }

        before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

        it 'returns status 200' do
          expect(response).to be_success
        end

        %w(id created_at updated_at body).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end

        context "comments in answer" do
          let(:comment){ comments.first }

          it 'included comment list in answer' do
            expect(response.body).to have_json_size(comments.size).at_path("comments")
          end

          %w(id content created_at commentable_type commentable_id).each do |attr|
            it "comment object in question contains #{attr} param" do
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
            end
          end

          it 'comment in answer includes user_email param' do
            expect(response.body).to be_json_eql(comment.user.email.to_json).at_path("comments/0/user_email")
          end
        end

        context "attachments in answer" do
          let(:attachment) { attachments.last }

          it 'included attachment list in answer' do
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

      context 'answer does not exists' do
        it 'return 404 status' do
          get "/api/v1/answers/123", params: { format: :json, access_token: access_token.token }
          expect(response).to be_not_found
        end
      end
    end
  end

end
