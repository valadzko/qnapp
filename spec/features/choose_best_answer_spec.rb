require_relative 'features_helper'

feature 'Select Best Answer', %q{
  In order to indicate best answer
  As author of the question
  I want to be able to pick the best answer
}do

  describe 'Author of the question' do
    scenario 'can see pick best answer button' do
      author = create(:user)
      question = create(:question, user: author)
      answer = create(:answer, question: question)
      sign_in(author)
      visit question_path(question)
      expect(page).to have_link 'pick-best-answer'
    end
    scenario 'pick best answer'
    scenario 'can not pick best answer as best answer'
#    scenario 'after pick best answer displayed first in the list'
#    scenario 'There is only one best answer at the time for one question'
  end

  # describe 'Non-author of the question' do
  #   scenario ''
  # end

#  scenario 'Author of the question re-pick best answer'



end
