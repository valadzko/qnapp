require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user)}
  let(:answer) {create(:answer, question: question, user: user)}
  context 'Validate changing answer accept status' do
    it 'change the answer status' do
      status = answer.accepted
      answer.mark_as_accepted
      expect(answer.accepted).to eq !status
    end
    it '(only one accepted) change accepted status from answer if other answer was accepted' do
      answer2 = create(:answer, question: question, user: user)
      answer.mark_as_accepted
      answer2.mark_as_accepted
      answer.reload
      answer2.reload
      expect(answer.accepted).to eq false
      expect(answer2.accepted).to eq true
    end
  end
end
