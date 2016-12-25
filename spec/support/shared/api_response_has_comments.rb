shared_examples_for "API Response Object Has Comments" do

  context "comments in response object" do
    let(:comment){ comments.first }

    it 'included comment list in response object' do
      expect(response.body).to have_json_size(comments.size).at_path(comments_path)
    end

    %w(id content created_at commentable_type commentable_id).each do |attr|
      it "comment in response object contains #{attr} param" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{comments_path}/0/#{attr}")
      end
    end

    it 'comment in response object includes user_email param' do
      expect(response.body).to be_json_eql(comment.user.email.to_json).at_path("#{comments_path}/0/user_email")
    end
  end
end
