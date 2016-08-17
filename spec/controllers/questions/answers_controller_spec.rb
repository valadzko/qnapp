require 'rails_helper'

RSpec.describe Questions::AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new answer' do
      it 'create a new answer ' do
        get :new, { question_id: question.id }
        expect(assigns(:answer)).to be_a_new(Answer)
      end

  end
end
