require 'rails_helper'

feature 'User can vote for answer', %q(
  In order to change the rating of a answer
  As an authenticated user
  I'd like to be able to vote for answer
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'when the user is authenticated' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote for answer (like)', js: true do
      within '.answers' do
        find('.like').click
        wait_for_ajax
      end

      expect(answer.reload.votes_sum).to eq 1

      within '.alerts' do
        expect(page).to have_content 'You voted for the answer'
      end
    end

    scenario 'vote for answer (dislike)', js: true do
      within '.answers' do
        find('.dislike').click
        wait_for_ajax
      end

      expect(answer.reload.votes_sum).to eq -1

      within '.alerts' do
        expect(page).to have_content 'You voted down the answer'
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
