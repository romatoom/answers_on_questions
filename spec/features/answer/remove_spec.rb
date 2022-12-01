require 'rails_helper'

feature 'The author can delete his answer', %q(
  In order to delete an answer to a question
  As an authenticated user and answer author
  I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }

  given(:question) { create(:question, author: user) }

  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    scenario 'answer author can delete an answer', js: true do
      sign_in(user)
      visit question_path(question)

      find('.remove_answer_btn').click

      expect(page).to have_content('Answer has been removed successfully.')

      within ('.answers') do
        expect(page).to have_content('No answers')
      end
    end

    scenario "non-authored user can't delete the answer", js: true do
      sign_in(user_not_author)
      visit question_path(question)

      expect(page).to_not have_selector('.remove_answer_btn')
    end
  end

  scenario "Unuthenticated answer author can't delete an answer", js: true do
    visit question_path(question)

    expect(page).to_not have_selector('.remove_answer_btn')
  end
end
