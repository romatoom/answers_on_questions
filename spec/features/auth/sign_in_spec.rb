require 'rails_helper'

feature 'User can sign in', %q(
  In order to get advanced features in the system
  As an unauthenticated user
  I'd like to be able to sign in
) do

  given(:user) { create(:user) }
  given(:wrong_user) { OpenStruct.new(attributes_for(:user, :wrong_email)) }

  given(:login_at_some_user) do
    lambda do |user|
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end

  describe 'Unauthenticated user can sign in using the button' do
    background do
      visit root_path
      find('#sign_in').click
    end

    scenario 'Registered user tries to sign in' do
      login_at_some_user.call(user)
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Unregistered user tries to sign in' do
      login_at_some_user.call(wrong_user)
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  scenario 'Authenticated user try sign in directly' do
    visit root_path
    expect(page).to have_selector('#sign_in')
    sign_in(user)
    expect(page).to_not have_selector('#sign_in')

    visit new_user_session_path
    expect(page).to have_content 'You are already signed in.'
  end
end
