require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
   end

   describe 'for admin' do
     let(:user) { create(:user, admin: true) }

     it { should be_able_to :manage, :all }
   end

   describe 'for user' do
     let(:user) { create(:user) }

     it { should_not be_able_to :manage, :all }
     it { should be_able_to :read, :all }
     it { should be_able_to :create, Question }
     it { should be_able_to :create, Answer }
     it { should be_able_to :create, Comment }

     context "author" do
       let(:question) { create(:question, user: user) }
       let(:answer) { create(:answer, question: question, user: user) }
       let(:comment){ create(:comment, user: user) }

       it { should be_able_to :update, question, user: user }
       it { should be_able_to :update, answer, user: user }
       it { should be_able_to :destroy, question, user: user }
       it { should be_able_to :destroy, answer, user: user }
       it { should be_able_to :destroy, comment, user: user }
       it { should be_able_to :accept, answer, user: user }
       it { should_not be_able_to :upvote, answer, user: user}
       it { should_not be_able_to :downvote, answer, user: user}
       it { should_not be_able_to :resetvote, answer, user: user}
     end

     context "non-author" do
       let(:other) { create(:user) }
       let(:other_question) { create(:question, user: other) }
       let(:other_answer) { create(:answer, question: other_question, user: other) }
       let(:other_comment){ create(:comment, user: other) }

       it { should_not be_able_to :update, other_question, user: user }
       it { should_not be_able_to :update, other_answer, user: user }
       it { should_not be_able_to :destroy, other_question, user: user }
       it { should_not be_able_to :destroy, other_answer, user: user }
       it { should_not be_able_to :destroy, other_comment, user: user }
       it { should_not be_able_to :accept, other_answer, user: user }
       it { should be_able_to :upvote, other_answer, user: user}
       it { should be_able_to :downvote, other_answer, user: user}
       it { should be_able_to :resetvote, other_answer, user: user}
     end

     context 'profile' do
       it { should be_able_to :me, User }
       it { should be_able_to :all, User }
     end
   end
end
