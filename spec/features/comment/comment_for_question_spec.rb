require 'rails_helper'

feature 'User can comment question', %q(
  In order to write comments to question
  As an authenticated user
  I'd like to be able to comment question
) do

  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }

  context 'multiple sessions', js: true do
    scenario "question comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_selector('.comment')
          expect(page).to_not have_content 'Question comment'
        end
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_selector('.comment')
          expect(page).to_not have_content 'Question comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_selector('.comment')
          expect(page).to_not have_content 'Question comment'
        end
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Type your comment', with: 'Question comment'
          click_on 'Comment'
          wait_for_ajax
        end

        within '.alerts' do
          expect(page).to have_content 'Comment has been added successfully'
        end

        within '.question .comments' do
          expect(page).to have_content "Comment by #{user.email}"
          expect(page).to have_content 'Question comment'
          expect(page).to have_content "#{question.comments.last.formatted_creation_date}"
        end
      end

      Capybara.using_session('another_user') do
        within '.question .comments' do
          expect(page).to have_content "Comment by #{user.email}"
          expect(page).to have_content 'Question comment'
          expect(page).to have_content "#{question.comments.last.formatted_creation_date}"
        end
      end

      Capybara.using_session('guest') do
        within '.question .comments' do
          expect(page).to have_content "Comment by #{user.email}"
          expect(page).to have_content 'Question comment'
          expect(page).to have_content "#{question.comments.last.formatted_creation_date}"
        end
      end
    end
  end

  context 'when the user is unauthenticated' do
    background do
      visit question_path(question)
    end

    scenario 'no showed form for add comment', js: true do
      within '.question' do
        expect(page).to_not have_selector('.add_comment')
      end
    end
  end
end
