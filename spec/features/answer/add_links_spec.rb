require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given(:question) { create(:question, author: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds link when asks answer', js: true do
    fill_in 'You can answer the question here', with: 'Answer text'

    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
    end
  end
end
