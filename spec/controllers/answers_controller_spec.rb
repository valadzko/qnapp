require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create answer' do
    sign_in_user
    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves new answer to database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change { question.answers.count }.by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end

      it 'associates new answer with current user' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(assigns(:answer).user).to eq subject.current_user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end

    context 'author of answer' do
      it 'deletes the answer' do
        expect{delete :destroy, id: @answer, question_id: @question}.to change(Answer, :count).by(-1)
      end

      it 'redirect to question path' do
        delete :destroy, id: @answer, question_id: @question
        expect(response).to redirect_to @question
      end
    end

    context 'not an author of question' do
      before do
        sign_out(@user)
        sign_in(create(:user))
      end

      it 'does not delete answer' do
        expect{ delete :destroy, id: @answer, question_id: @question }.to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        delete :destroy, id: @answer, question_id: @question
        expect(response).to redirect_to @question
      end
    end
  end
end
