require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url_google) { 'https://google.com' }
  given(:url_dzen) { 'https://dzen.ru' }

  scenario 'User add several links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'Google link'
    fill_in 'URL', with: url_google

    click_on '+ Add link'

    within all(".nested-fields").last do
      fill_in 'Link name', with: 'Dzen link'
      fill_in 'URL', with: url_dzen
    end

    click_on 'Ask'

    within ".question" do
      expect(page).to have_link 'Google link', href: url_google
      expect(page).to have_link 'Dzen link', href: url_dzen
    end
  end

  scenario 'User add link with validation errors when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My link'

    click_on 'Ask'

    expect(page).to have_content "Links url can't be blank"

    fill_in 'URL', with: 'Abc123'

    expect(page).to have_content "Links url must be a valid URL"
  end
end
