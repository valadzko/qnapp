shared_examples_for "Votable" do
  context 'Validate voting' do
    before do
      @voting_user = create(:user)
      @rating_before = subject.rating
    end

    it 'increase rating by 1' do
      subject.upvote(@voting_user)
      expect(subject.rating).to be (@rating_before + 1)
    end

    it 'does not increase rating for double upvote' do
      subject.upvote(@voting_user)
      subject.upvote(@voting_user)
      expect(subject.rating).to be (@rating_before + 1)
    end

    it 'decrease rating' do
      subject.downvote(@voting_user)
      expect(subject.rating).to be (@rating_before - 1)
    end

    it 'does not decrease rating for double downvote' do
      subject.downvote(@voting_user)
      subject.downvote(@voting_user)
      expect(subject.rating).to be (@rating_before - 1)
    end

    it 'cancel vote' do
      subject.upvote(@voting_user)
      subject.reset_vote(@voting_user)
      expect(subject.rating).to be @rating_before
    end
  end
end
