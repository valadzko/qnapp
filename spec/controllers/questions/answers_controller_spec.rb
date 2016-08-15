require 'rails_helper'

RSpec.describe Questions::AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index with :question_id' do
      it 'populates an array of all answers for the question' do
      #a = create(:answer, question: question)
      #puts "YOUR ANSWER IS : #{a.inspect}"

        puts "Your question is : #{question.inspect}"
        question
        a1 = create(:answer, question: question)
        a2 = create(:answer, question: question)

        get :index, question_id: question.id
        expect(assigns(:answers)).to match_array[a1,a2]
      end

  end
end
