require 'rails_helper'

feature 'User can vote for question', %q(
  In order to change the rating of a question
  As an authenticated user
  I'd like to be able to vote for question
) do

  given!(:user) { create(:user) }
  given!(:question_author) { create(:user) }
  given!(:question) { create(:question, author: question_author) }

  context 'when the user is authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'like question and reset vote', js: true do
      within '.question' do
        expect(page).to_not have_content 'Revote'

        find('.like').click
        wait_for_ajax

        expect(question.reload.votes_sum).to eq 1
        expect(page).to have_content 'Revote'

        click_on 'Revote'
        wait_for_ajax

        expect(question.reload.votes_sum).to eq 0
        expect(page).to_not have_content 'Revote'
      end

      within '.alerts' do
        expect(page).to have_content 'You voted for the question'
      end
    end

    scenario 'dislike question and reset vote', js: true do
      within '.question' do
        expect(page).to_not have_content 'Revote'

        find('.dislike').click
        wait_for_ajax

        expect(question.reload.votes_sum).to eq -1
        expect(page).to have_content 'Revote'

        click_on 'Revote'
        wait_for_ajax

        expect(question.reload.votes_sum).to eq 0
        expect(page).to_not have_content 'Revote'
      end

      within '.alerts' do
        expect(page).to have_content 'You voted down the question'
      end
    end
  end

  context 'when the user is unauthenticated' do
    background do
      visit question_path(question)
    end

    scenario 'no showed button for like', js: true do
      within '.question' do
        expect(page).to_not have_selector('.like')
      end
    end

    scenario 'no showed button for dislike', js: true do
      within '.question' do
        expect(page).to_not have_selector('.dislike')
      end
    end
  end

end
