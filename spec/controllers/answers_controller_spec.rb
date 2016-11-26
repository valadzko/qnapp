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

      it 'render create template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }

    context 'regular patch' do
      before do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      end
      it 'assings the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: {body: 'new answer body for question'}, format: :js
      answer.reload
      expect(answer.body).to eq 'new answer body for question'
    end
  end

  describe 'GET #accept' do
    sign_in_user
    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end
    context 'author of question' do
      before do
        @accepted = @answer.accepted
        xhr :get, :accept, id: @answer.id, question_id: @question.id, format: :js
      end
      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq @answer
      end
      it 'change answer accepted status' do
        @answer.reload
        expect(@answer.accepted).to eq !@accepted
      end
    end

    context 'Non-author of question' do
      it 'can not change the accepted status of answer' do
        sign_out(@user)
        sign_in(create(:user))
        accepted = @answer.accepted
        xhr :get, :accept, id: @answer.id, question_id: @answer.question.id, format: :js
        @answer.reload
        expect(@answer.accepted).to eq accepted
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
        expect{delete :destroy, id: @answer, question_id: @question, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, id: @answer, question_id: @question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not an author of question' do
      before do
        sign_out(@user)
        sign_in(create(:user))
      end

      it 'does not delete answer' do
        expect{ delete :destroy, id: @answer, question_id: @question, format: :js }.to_not change(Answer, :count)
      end

      it 'render template destroy' do
        delete :destroy, id: @answer, question_id: @question, format: :js
        expect(response).to redirect_to question_path(@question)
      end
    end
  end
end
