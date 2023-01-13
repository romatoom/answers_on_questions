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
      find('#answer_files', visible: false)
        .attach_file([
          "#{Rails.root}/spec/files_for_active_storage/file-1.txt",
          "#{Rails.root}/spec/files_for_active_storage/file-2.txt"
        ])
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

  context 'multiple sessions' do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:question) { create(:question, author: user) }

    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another user') do
        sign_in(another_user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content 'Answer body'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_content 'Answer body'
        end
      end

      Capybara.using_session('user') do
        fill_in 'You can answer the question here', with: 'Answer body'
        click_on 'Answer'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'Answer has been created successfully.'

        within '.answers' do
          expect(page).to have_content 'Answer body'
        end
      end

      Capybara.using_session('another user') do
        within '.answers' do
          expect(page).to have_content 'Answer body'

          expect(page).to_not have_content 'Revote'

          find('.like').click
          wait_for_ajax
        end

        within '.alerts' do
          expect(page).to have_content 'You voted for the answer'
        end

        within '.answers' do
          expect(page).to have_content 'Revote'
          expect(page).to have_content 'Votes: 1'

          click_on 'Revote'
          wait_for_ajax

          expect(page).to_not have_content 'Revote'
          expect(page).to have_content 'Votes: 0'
        end

        within '.alerts' do
          expect(page).to have_content 'You reset vote for the answer'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer body'
        end
      end
    end
  end

  scenario "Unauthenticate user can't write an answer" do
    visit question_path(question)

    fill_in 'You can answer the question here', with: 'Text text text'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
