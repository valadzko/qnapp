require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #new answer' do
    before { get :new, params: { question_id: question.id } }

      it 'create a new answer ' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'should render new view' do
        expect(response).to render_template :new
      end
  end

  describe 'POST #create answer' do
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
end
