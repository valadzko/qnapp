require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    describe 'POST #create' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves new question in database ' do
          expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end

        it 'associates question with current_user' do
          # post :create, question: attributes_for(:question)
          # expect
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assign a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'should render a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'my new long valid body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'my new long valid body'
      end

      it 'redirect to updated @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to :question
      end
    end

    # TODO add case for body length gt 15
    context 'with invalid attributes' do

      it 'does not change question attributes' do
        title_before_try = question.title
        body_before_try = question.body
        patch :update, id: question, question: { title: 'new title', body: nil }
        question.reload
        expect(question.title).to eq title_before_try
        expect(question.body).to eq body_before_try
      end

      it 're-renders edit view' do
        patch :update, id: question, question: { title: 'new title', body: nil }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of question' do
        before do
          author = create(:user)
          sign_in(author)
          @question = create(:question, user: author)
        end
        it 'delete question' do
          expect{delete :destroy, id: @question}.to change(Question, :count).by(-1)
        end
        it 'redirects to questions view' do
          delete :destroy, id: @question
          expect(response).to redirect_to questions_path
        end
    end

    context 'not an author of the question tries delete question' do
      sign_in_user
      before do
        @question = create(:question, user: @user)
        sign_out(@user)
        sign_in(create(:user))
      end

      it 'does not delete question' do
        expect{ delete :destroy, id: @question }.to_not change(Question, :count)
      end
      it 'should redirect to questions' do
        delete :destroy, id: @question
        expect(response).to redirect_to questions_path
      end
    end
  end
end
