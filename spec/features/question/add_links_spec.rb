require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: url

    click_on 'Ask'

    expect(page).to have_link 'My link', href: url
  end
end
