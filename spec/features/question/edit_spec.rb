require 'rails_helper'

feature 'The author can edit his question', %q(
  In order to edit a question
  As an authenticated user and question author
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }

  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    describe 'question author' do
      background do
        sign_in(user)
        visit questions_path
      end

      scenario 'can edit question', js: true do
        expect(page).to have_selector('.edit_form', visible: false)

        find('.edit_question_btn').click

        expect(page).to have_selector('.edit_question_btn', visible: false)
        expect(page).to have_selector('.edit_form', visible: true)

        fill_in 'Title', with: 'New question title'
        fill_in 'Body', with: 'New question body'

        click_on 'Save'

        expect(page).to have_selector('.edit_question_btn', visible: true)
        expect(page).to have_selector('.edit_form', visible: false)

        expect(page).to have_content('Question has been edited successfully.')

        within("#question_#{question.id}") do
          expect(page).to have_content('New question title')
        end
      end

      scenario 'can add files when editing question', js: true do
        find('.edit_question_btn').click

        attach_file 'Add more file(s)', ["#{Rails.root}/spec/files_for_active_storage/file-1.txt", "#{Rails.root}/spec/files_for_active_storage/file-2.txt"]
        click_on 'Save'

        within("#question_#{question.id}") do
          expect(page).to have_link 'file-1.txt'
          expect(page).to have_link 'file-2.txt'
        end

        find('.edit_question_btn').click

        attach_file 'Add more file(s)', ["#{Rails.root}/spec/files_for_active_storage/file-3.txt", "#{Rails.root}/spec/files_for_active_storage/file-4.txt"]
        click_on 'Save'

        within("#question_#{question.id}") do
          expect(page).to have_link 'file-1.txt'
          expect(page).to have_link 'file-2.txt'
          expect(page).to have_link 'file-3.txt'
          expect(page).to have_link 'file-4.txt'
        end
      end

      scenario 'try edit question with errors', js: true do
        expect(page).to have_selector('.edit_form', visible: false)

        find('.edit_question_btn').click

        expect(page).to_not have_selector('.edit_question_btn')
        expect(page).to have_selector('.edit_form')

        fill_in 'Title', with: ''
        fill_in 'Body', with: ''

        click_on 'Save'

        within '.question-errors' do
          expect(page).to have_content ("Title can't be blank")
          expect(page).to have_content ("Body can't be blank")
        end
      end
    end

    scenario "not question author can't edit the question", js: true do
      sign_in(user_not_author)
      visit questions_path

      expect(page).to_not have_selector('.edit_question_btn')
    end
  end

  scenario "Unuthenticated user can't edit an question", js: true do
    visit questions_path

    expect(page).to_not have_selector('.edit_question_btn')
  end
end
