require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :answers }
  it { should have_many :questions }

  context 'Validate authority of question' do
    it 'from user who created question (is author)' do
      # user = create(:user)
      # sign_in(user)
      # question = create(:question, user: @user)
      # expect(@user.author_of?(question)).to be true
    end

    it 'from user who did not create question (is not author)' do
      # user = create(:user)
      # sign_in(user)
      # question = create(:question, user: user)
      # user2 = create(:user)
      # expect(user2.author_of?(question)).to be false
    end
  end

  # it "validates authority of user who created question" do
  #
  # end
  #
  # it 'validates authority of user who did not create question' do
  #
  # end
end
