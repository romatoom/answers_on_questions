require 'rails_helper'

feature 'User can sign up', %q(
  In order to get advanced features in the system and enter it
  As an unauthorized user
  I would like to be able to sign up
) do

  given(:new_user) { OpenStruct.new(attributes_for(:user)) }

  given(:new_user_with_invalid_password_confirmation) do
    OpenStruct.new(attributes_for(:user, password_confirmation: 'wrong password'))
  end

  given(:user) { create(:user) }

  given(:register_at_some_user) do
    lambda do |user|
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      find('#submit_register').click
    end
  end

  describe 'Unauthenticated user can sign up using the button' do
    background do
      visit root_path
      find('#sign_up').click
    end

    scenario 'User tries to sign up' do
      register_at_some_user.call(new_user)
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'User tries to sign up with invalid password confirmation' do
      register_at_some_user.call(new_user_with_invalid_password_confirmation)
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'User tries to sign up with takened email' do
      register_at_some_user.call(user)
      expect(page).to have_content "Email has already been taken"
    end
  end

  scenario 'Authenticated user try sign up directly' do
    visit root_path
    expect(page).to have_selector('#sign_up')
    sign_in(user)
    expect(page).to_not have_selector('#sign_up')

    visit new_user_session_path
    expect(page).to have_content 'You are already signed in.'
  end
end
