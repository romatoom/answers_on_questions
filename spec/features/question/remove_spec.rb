require 'rails_helper'

feature 'The author can delete his question', %q(
  In order to delete a question
  As an authenticated user and question author
  I'd like to be able to delete my question
) do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }

  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    scenario 'question author can delete him' do
      sign_in(user)
      visit questions_path

      find('.remove_question_btn').click
      expect(page).to have_content('Question has been removed successfully.')
    end

    scenario "non-authored user can't delete the question" do
      sign_in(user_not_author)
      visit questions_path

      expect(page).to_not have_selector('.remove_question_btn')
    end
  end

  scenario "Unuthenticated question author can't delete an question" do
    visit questions_path

    expect(page).to_not have_selector('.remove_question_btn')
  end
end
