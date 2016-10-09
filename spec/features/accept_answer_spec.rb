require_relative 'features_helper'

feature 'Select Best Answer', %q{
  In order to indicate best answer
  As author of the question
  I want to be able to pick the best answer
}do
  describe 'Author of the question' do

    before(:each) do
      author = create(:user)
      @question = create(:question, user: author)
      @answer = create_list(:answer, 3, question: @question, user: author)
      sign_in(author)
    end

    scenario 'can see accept answer button for answer' do
      visit question_path(@question)
      expect(page).to have_css('.accept-link', count: 3)
    end

    scenario 'mark accepted answer', js: true do
      visit question_path(@question)
      expect(page).to have_css('.accept-link', count: 3)
      expect(page).to_not have_css('.accepted-link')
      first(:xpath, '//*[@class="accept-link"]').click
      expect(page).to have_css('.accept-link', count: 2)
      expect(page).to have_css('.accepted-link', count: 1)
    end

    scenario 'can unmark accepted answer', js: true do
      @answer.first.mark_as_accepted
      visit question_path(@question)
      expect(page).to have_css('.accept-link', count: 2)
      expect(page).to have_css('.accepted-link')
      find(:xpath, '//*[@class="accepted-link"]').click
      expect(page).to have_css('.accept-link', count: 3)
    end

    scenario 'accepted answer displayed first', js: true do
      visit question_path(@question)
      within '.answers' do
        expect(page).to have_css('.accept-link', count: 3)
        expect(page).to_not have_css('.accepted-link')
        first_before = first('.answer').inspect
        all(:xpath, '//*[@class="accept-link"]')[1].click
        sleep(2)
        first_after = first('.answer').inspect
        expect(first_after).to_not eq first_before
      end
    end
  end

  describe 'Non-author of the question' do
    before do
      @answer = create(:answer)
      sign_in(create(:user))
    end
     scenario 'can not see accept answer link' do
       visit question_path(@answer.question)
       expect(page).to_not have_css('.accept-link')
     end
     scenario 'can see accepted mark' do
       @answer.mark_as_accepted
       sign_out
       visit question_path(@answer.question)
       expect(page).to have_css("img[src*='accepted']")
     end
   end
end
