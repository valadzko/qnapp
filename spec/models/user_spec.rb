require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :answers }
  it { should have_many :questions }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user) }
  context 'Validate authority of question' do
    it 'from user who created question (is author)' do
      expect(user.author_of?(question)).to be true
    end

    it 'from user who did not create question (is not author)' do
      not_author = create(:user)
      expect(not_author.author_of?(question)).to be false
    end
  end

  context 'Validate authority of answer' do
    let(:answer){ create(:answer, user: user) }

    it 'from user who created answer (is author)' do
      expect(user.author_of?(answer)).to be true
    end

    it 'from user who did not create answer (is not author)' do
      not_author = create(:user)
      expect(not_author.author_of?(answer)).to be false
    end
  end
end
