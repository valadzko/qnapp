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

    it 'builds new attachments for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
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

        it 'associates new answer with current user' do
          post :create, question: attributes_for(:question)
          expect(assigns(:question).user).to eq subject.current_user
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

    it 'builds new attachments for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'should render a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'my new long valid body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'my new long valid body'
      end

      it 'render template update' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    # TODO add case for body length gt 15
    context 'with invalid attributes' do

      it 'does not change question attributes' do
        title_before_try = question.title
        body_before_try = question.body
        patch :update, id: question, question: { title: 'new title', body: nil }, format: :js
        question.reload
        expect(question.title).to eq title_before_try
        expect(question.body).to eq body_before_try
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
