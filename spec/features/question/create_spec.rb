require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
) do

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    given(:user) { create(:user) }

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'
      click_on 'Ask'

      expect(current_path).to eq question_path(user.questions.last)
      expect(page).to have_content 'Question has been created successfully.'

      within '.question' do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text text text'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
