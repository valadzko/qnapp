require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'GET #index' do
    let!(:user){ create(:user) }
    let!(:question){ create(:question, user: user) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }

    before do
      get :index, xhr: true, params: { question_id: question.id, format: :js }
    end
    it 'populates array of comments for given question' do
      expect(assigns(:comments)).to match_array(comments)
    end
    it 'render index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    let!(:user){ create(:user) }
    let!(:question){ create(:question, user: user) }

    context 'with valid attributes' do
      before do
        sign_in user
        post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js }
      end
      it 'saves new comment to database' do
        expect{ post :create, params: {question_id: question.id, comment: attributes_for(:comment)}}.to change(Comment, :count).by(1)
      end
      it 'associate new comment with commentable(question)' do
        expect(assigns(:comment).commentable).to eq question
      end
      it 'associate new comment with current user' do
        expect(assigns(:comment).user).to eq user
      end
    end

  end
end
