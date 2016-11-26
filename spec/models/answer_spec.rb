require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many :attachments }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should accept_nested_attributes_for :attachments }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user)}
  let(:answer) {create(:answer, question: question, user: user)}
  context 'Validate changing answer accept status' do
    it 'change the answer status' do
      answer.mark_as_accepted
      expect(answer).to be_accepted
    end
    it '(only one accepted) change accepted status from answer if other answer was accepted' do
      answer2 = create(:answer, question: question, user: user)
      answer.mark_as_accepted
      answer2.mark_as_accepted
      answer.reload
      answer2.reload
      expect(answer).to_not be_accepted
      expect(answer2).to be_accepted
    end
  end

  context 'Validate voting for answer' do
    before(:each) do
      @voting_user = create(:user)
      @rating_before = answer.rating
    end
    it 'increase rating of answer' do
      answer.upvote(@voting_user)
      expect(answer.rating).to be (@rating_before + 1)
      # double vote up does nothing
      answer.upvote(@voting_user)
      expect(answer.rating).to be (@rating_before + 1)
    end

    it 'decrease rating of answer' do
      answer.downvote(@voting_user)
      expect(answer.rating).to be (@rating_before - 1)
      # double vote down does nothing
      answer.downvote(@voting_user)
      expect(answer.rating).to be (@rating_before - 1)
    end

    it 'cancel vote for answer' do
      answer.upvote(@voting_user)
      expect(answer.rating).to be (@rating_before + 1)
      answer.reset_vote(@voting_user)
      expect(answer.rating).to be @rating_before
    end
  end
end
