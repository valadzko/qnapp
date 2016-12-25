shared_examples_for "Commentable" do
  context 'Validate voting for answer' do
    before do
      @voting_user = create(:user)
      @rating_before = answer.rating
    end

    it 'increase rating of answer by 1' do
      answer.upvote(@voting_user)
      expect(answer.rating).to be (@rating_before + 1)
    end

    it 'does not increase rating for double upvote' do
      answer.upvote(@voting_user)
      answer.upvote(@voting_user)
      expect(answer.rating).to be (@rating_before + 1)
    end

    it 'decrease rating of answer' do
      answer.downvote(@voting_user)
      expect(answer.rating).to be (@rating_before - 1)
    end

    it 'does not decrease rating for double downvote' do
      answer.downvote(@voting_user)
      answer.downvote(@voting_user)
      expect(answer.rating).to be (@rating_before - 1)
    end

    it 'cancel vote for answer' do
      answer.upvote(@voting_user)
      answer.reset_vote(@voting_user)
      expect(answer.rating).to be @rating_before
    end
  end

end
