require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #new answer' do
    sign_in_user
    before { get :new, params: { question_id: question.id } }

      it 'create a new answer ' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'should render new view' do
        expect(response).to render_template :new
      end
  end

  describe 'POST #create answer' do
    sign_in_user
    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves new answer to database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(Answer, :count).by(1)
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change { question.answers.count }.by(1)
      end

      it 'redirect to question view' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 're-render :new view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes (author of answer)' do
      it 'should delete the answer' do
        author = create(:user)
        sign_in(author)
        question = create(:question, user: author)
        answer = create(:answer, question: question, user: author)
        expect{delete :destroy, id: answer, question_id: question}.to change(Answer, :count).by(-1)
      end

      it 'should re-render question path' do
        author = create(:user)
        sign_in(author)
        question = create(:question, user: author)
        answer = create(:answer, question: question, user: author)
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes (not an author of the question)' do
      it 'should re-render question path' do
        author = create(:user)
        sign_in(author)
        question = create(:question, user: author)
        answer = create(:answer, question: question, user: author)
        sign_out(author)
        not_an_answerer = create(:user)
        sign_in(not_an_answerer)
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question
      end
    end
  end


end
