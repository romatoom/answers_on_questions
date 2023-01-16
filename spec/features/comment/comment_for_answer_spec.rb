require 'rails_helper'

feature 'User can comment answer', %q(
  In order to write comments to answer
  As an authenticated user
  I'd like to be able to comment answer
) do

  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:answer) { create(:answer) }
  given(:question) { answer.question }

  context 'multiple sessions', js: true do
    scenario "answer comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_selector('.comment')
          expect(page).to_not have_content 'Answer comment'
        end
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_selector('.comment')
          expect(page).to_not have_content 'Answer comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_selector('.comment')
          expect(page).to_not have_content 'Answer comment'
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Type your comment', with: 'Answer comment'
          click_on 'Comment'
          wait_for_ajax
        end

        within '.alerts' do
          expect(page).to have_content 'Comment has been added successfully'
        end

        within '.answers .comments' do
          expect(page).to have_content "Comment by #{user.email}"
          expect(page).to have_content 'Answer comment'
          expect(page).to have_content "#{answer.comments.last.formatted_creation_date}"
        end
      end

      Capybara.using_session('another_user') do
        within '.answers .comments' do
          expect(page).to have_content "Comment by #{user.email}"
          expect(page).to have_content 'Answer comment'
          expect(page).to have_content "#{answer.comments.last.formatted_creation_date}"
        end
      end

      Capybara.using_session('guest') do
        within '.answers .comments' do
          expect(page).to have_content "Comment by #{user.email}"
          expect(page).to have_content 'Answer comment'
          expect(page).to have_content "#{answer.comments.last.formatted_creation_date}"
        end
      end
    end
  end

  scenario "answer comment with error", js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Comment'
      wait_for_ajax
    end

    within '.alerts' do
      expect(page).to have_content 'Error add comment for answer'
    end

    within '.answers .comments' do
      expect(page).to_not have_content "Comment by #{user.email}"
      expect(page).to_not have_content 'Answer comment'
    end
  end

  scenario 'when the user is unauthenticated' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector('.add_comment')
    end
  end
end
