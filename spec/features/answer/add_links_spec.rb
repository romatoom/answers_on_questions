require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url_google) { 'https://google.com' }
  given(:url_dzen) { 'https://dzen.ru' }
  given(:question) { create(:question, author: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds several links when asks answer', js: true do
    fill_in 'You can answer the question here', with: 'Answer text'

    fill_in 'Link name', with: 'Google link'
    fill_in 'URL', with: url_google

    click_on '+ Add link'

    within all(".nested-fields").last do
      fill_in 'Link name', with: 'Dzen link'
      fill_in 'URL', with: url_dzen
    end

    click_on 'Answer'

    within all('.answers').last do
      expect(page).to have_link 'Google link', href: url_google
      expect(page).to have_link 'Dzen link', href: url_dzen
    end
  end

  scenario 'User adds link with validation errors when asks answer', js: true do
    fill_in 'You can answer the question here', with: 'Answer text'

    fill_in 'Link name', with: 'My link'

    click_on 'Answer'

    expect(page).to have_content "Links url can't be blank"

    fill_in 'URL', with: 'Abc123'

    expect(page).to have_content "Links url must be a valid URL"
  end
end
