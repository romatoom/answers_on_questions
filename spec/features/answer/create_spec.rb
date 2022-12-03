require 'rails_helper'

feature 'User can write an answer', %q(
  In order to answer the question
  As an authenticated user
  I'd like to be able to give an answer on the question page
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can write an answer', js: true do
      fill_in 'You can answer the question here', with: 'Text text text'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer has been created successfully.'

      within '.answers' do
        expect(page).to have_content 'Text text text'
      end
    end

    scenario 'can write an answer with attached files', js: true do
      fill_in 'You can answer the question here', with: 'Text text text'
      attach_file 'File(s)', ["#{Rails.root}/spec/files_for_active_storage/file-1.txt", "#{Rails.root}/spec/files_for_active_storage/file-2.txt"]
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'file-1.txt'
        expect(page).to have_link 'file-2.txt'
      end
    end

    scenario 'create answer with error', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticate user can't write an answer" do
    visit question_path(question)

    fill_in 'You can answer the question here', with: 'Text text text'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
