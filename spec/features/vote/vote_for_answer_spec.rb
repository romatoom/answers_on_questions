require 'rails_helper'

feature 'User can vote for answer', %q(
  In order to change the rating of a answer
  As an authenticated user
  I'd like to be able to vote for answer
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer_author) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: answer_author) }

  context 'when the user is authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'like answer and reset vote', js: true do
      within '.answers' do
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

    scenario 'dislike answer and reset vote', js: true do
      within '.answers' do
        expect(page).to_not have_content 'Revote'

        find('.dislike').click
        wait_for_ajax
      end

      within '.alerts' do
        expect(page).to have_content 'You voted down the answer'
      end

      within '.answers' do
        expect(page).to have_content 'Revote'
        expect(page).to have_content 'Votes: -1'

        click_on 'Revote'
        wait_for_ajax

        expect(page).to_not have_content 'Revote'
        expect(page).to have_content 'Votes: 0'
      end

      within '.alerts' do
        expect(page).to have_content 'You reset vote for the answer'
      end
    end
  end

  context 'when the user is unauthenticated' do
    background do
      visit question_path(question)
    end

    scenario 'no showed button for like', js: true do
      within '.answers' do
        expect(page).to_not have_selector('.like')
      end
    end

    scenario 'no showed button for dislike', js: true do
      within '.answers' do
        expect(page).to_not have_selector('.dislike')
      end
    end
  end

end
