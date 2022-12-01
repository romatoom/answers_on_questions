require 'rails_helper'

feature 'The author can edit his answer', %q(
  In order to edit a answer
  As an authenticated user and answer author
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }

  given!(:answer) { create(:answer, author: user) }

  describe 'Authenticated user' do
    describe 'answer author' do
      background do
        sign_in(user)
        visit question_path(answer.question)
      end

      scenario 'can edit answer', js: true do
        expect(page).to have_selector('.edit_form', visible: false)

        find('.edit_answer_btn').click

        expect(page).to have_selector('.edit_answer_btn', visible: false)
        expect(page).to have_selector('.edit_form', visible: true)

        find('.answers #answer_body').fill_in(with: 'New answer body')

        click_on 'Save'

        expect(page).to have_selector('.edit_answer_btn', visible: true)
        expect(page).to have_selector('.edit_form', visible: false)

        expect(page).to have_content('Answer has been edited successfully.')

        within("#answer_#{answer.id}") do
          expect(page).to have_content('New answer body')
        end
      end

      scenario 'try edit answer with errors', js: true do
        expect(page).to have_selector('.edit_form', visible: false)

        find('.edit_answer_btn').click

        expect(page).to_not have_selector('.edit_answer_btn')
        expect(page).to have_selector('.edit_form')

        find('.answers #answer_body').fill_in(with: '')

        click_on 'Save'

        within '.answer_errors' do
          expect(page).to have_content ("Body can't be blank")
        end
      end
    end

    scenario "not answer author can't edit the answer", js: true do
      sign_in(user_not_author)
      visit question_path(answer.question)

      expect(page).to_not have_selector('.edit_answer_btn')
    end
  end

  scenario "Unuthenticated user can't edit an answer", js: true do
    visit question_path(answer.question)

    expect(page).to_not have_selector('.edit_answer_btn')
  end
end
