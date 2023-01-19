require 'rails_helper'

feature 'User can sign in via github', %q(
  In order to get advanced features in the system
  As an unauthenticated user
  I'd like to be able to sign in via github
) do
  describe "access top page" do
    it "can sign in user with Github account" do
      visit new_user_session_path
      expect(page).to have_content "Sign in with GitHub"

      github_mock_auth_hash

      click_link "Sign in with GitHub"

      within '.alerts' do
        expect(page).to have_content "Successfully authenticated from Github account."
      end

      expect(page).to have_content "Sign out"
    end

    it "can handle authentication error" do
      visit new_user_session_path
      expect(page).to have_content "Sign in with GitHub"

      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      click_link "Sign in with GitHub"

      within '.alerts' do
        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end
  end
end
