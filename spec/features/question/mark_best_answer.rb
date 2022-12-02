require 'rails_helper'

feature 'The author can mark best answer for his question', %q(
  In order to mark best answer for question
  As an authenticated user and question author
  I'd like to be able to mark best answer for my question
) do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }

  given!(:question) { create(:question, author: user) }

  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  describe 'Authenticated user' do
    describe 'question author' do
      background do
        sign_in(user)
      end

      describe 'if there is no better answer' do
        scenario 'mark best answer', js: true do
          visit question_path(question)

          within("#answer_#{answer1.id}") do
            expect(page).to_not have_content 'Best answer'
          end

          find("#answer_#{answer1.id} .mark_best_answer").click

          within("#answer_#{answer1.id}") do
            expect(page).to have_content 'Best answer'
          end

          first_answer = find(".answers li", match: :first)
          best_answer = find("#answer_#{answer1.id}")
          expect(first_answer).to eq best_answer
        end
      end

      describe 'if there is already a better answer' do
        given!(:answer1) { create(:answer, question: question, best: true) }
        given!(:answer2) { create(:answer, question: question) }

        scenario 'mark another best answer', js: true do
          visit question_path(question)

          within("#answer_#{answer1.id}") do
            expect(page).to have_content 'Best answer'
            expect(page).to_not have_selector(".mark_best_answer")
          end

          first_answer = find(".answers li", match: :first)
          best_answer = find("#answer_#{answer1.id}")
          expect(first_answer).to eq best_answer

          find("#answer_#{answer2.id} .mark_best_answer").click

          within("#answer_#{answer1.id}") do
            expect(page).to_not have_content 'Best answer'
            expect(page).to have_selector(".mark_best_answer")
          end

          within("#answer_#{answer2.id}") do
            expect(page).to have_content 'Best answer'
            expect(page).to_not have_selector(".mark_best_answer")
          end

          first_answer = find(".answers li", match: :first)
          best_answer = find("#answer_#{answer2.id}")
          expect(first_answer).to eq best_answer
        end
      end
    end

    scenario "not question author can't mark best answer for question", js: true do
      sign_in(user_not_author)
      visit question_path(question)

      expect(page).to_not have_selector('.mark_best_answer')
    end
  end

  scenario "Unuthenticated user can't mark best answer for question", js: true do
    visit questions_path

    expect(page).to_not have_selector('.mark_best_answer')
  end
end
