require 'rails_helper'

feature 'User can sign out', %q(
  In order to end a work session
  As an authenticated user
  I'd like to be able to sign out
) do

  given(:user) { create(:user) }

  scenario 'Authenticated user can sign out' do
    sign_in(user)

    find('#sign_out').click
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario "An unauthorized user does not have a sign out button" do
    expect(page).to_not have_selector('#sign_out')
  end
end
