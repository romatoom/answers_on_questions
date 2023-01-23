require 'rails_helper'

feature 'User can sign in via Telegram', %q(
  In order to get advanced features in the system
  As an unauthenticated user
  I'd like to be able to sign in via Telegram
) do
  describe 'Telegram' do
    context 'User try sign in with Telegram account' do
      context 'when email not confirmed' do
        background do
          visit new_user_session_path
          expect(page).to have_content 'Sign in with Telegram'

          telegram_mock_auth_hash

          click_link 'Sign in with Telegram'

          expect(current_url).to eq new_confirmed_email_url(provider: 'telegram', uid: '12345')

          within '.alerts' do
            expect(page).to have_content 'Confirm your email'
          end

          within 'h1' do
            expect(page).to have_content 'Confirm your email'
          end
        end

        scenario 'when fill email confirmation field' do
          fill_in 'Email', with: 'new@user.com'
          click_on 'Send confirmation email'

          within '.alerts' do
            expect(page).to have_content 'A confirmation link has been sent to your email.'
          end

          open_email('new@user.com')
          current_email.click_link 'Confirm EMAIL'

          expect(current_path).to eq new_user_session_path

          within '.alerts' do
            expect(page).to have_content 'Email is confirmed. Now you can sign in via Telegram.'
          end
        end

        scenario 'when not fill email confirmation field' do
          click_on 'Send confirmation email'

          expect(page).to have_content "Email can't be blank"
        end
      end

      context 'when email confirmed' do
        let!(:user) { create(:user, email: 'new@user.com') }
        let!(:authorization) { create(:authorization, user: user, provider: 'telegram', uid: '12345') }

        scenario 'successful sign in via telegram' do
          visit new_user_session_path
          expect(page).to have_content 'Sign in with Telegram'

          telegram_mock_auth_hash

          click_link 'Sign in with Telegram'

          within '.alerts' do
            expect(page).to have_content 'Successfully authenticated from Telegram account.'
          end

          expect(page).to have_content 'Sign out'
        end
      end
    end

    scenario 'when authentication error' do
      visit new_user_session_path
      expect(page).to have_content 'Sign in with Telegram'

      OmniAuth.config.mock_auth[:telegram] = :invalid_credentials

      click_link 'Sign in with Telegram'

      within '.alerts' do
        expect(page).to have_content 'Could not authenticate you from Telegram because "Invalid credentials"'
      end
    end
  end
end
