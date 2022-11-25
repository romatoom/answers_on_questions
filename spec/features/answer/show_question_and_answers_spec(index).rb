require 'rails_helper'

feature 'The user can view the question and the answers to it', %q(
  In order to view answers to a question
  As an any user
  I'd like to be able to view the question and its answers
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  before { create_list(:answer, 3, question: question, author: user) }

  scenario 'View the question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
