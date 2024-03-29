require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
) do

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    given(:user) { create(:user) }

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'
      click_on 'Ask'

      expect(current_path).to eq question_path(user.questions.last)
      expect(page).to have_content 'Question has been created successfully.'

      within '.question' do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text text text'
      end
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'
      find('#question_files')
        .attach_file([
          "#{Rails.root}/spec/files_for_active_storage/file-1.txt",
          "#{Rails.root}/spec/files_for_active_storage/file-2.txt"
        ])
      click_on 'Ask'

      expect(page).to have_link 'file-1.txt'
      expect(page).to have_link 'file-2.txt'
    end

    scenario 'asks a question with attach reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'

      within ".create-reward" do
        fill_in 'Label', with: 'Test reward'
        find('#question_reward_attributes_image')
          .attach_file("#{Rails.root}/spec/files_for_active_storage/reward.png")
      end

      click_on 'Ask'

      expect(page).to have_content 'Test reward'
      expect(page).to have_css("img[src*='reward.png']")
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'multiple sessions' do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }

    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit questions_path

        within '.questions' do
          expect(page).to_not have_content 'Question title'
        end
      end

      Capybara.using_session('guest') do
        visit questions_path

        within '.questions' do
          expect(page).to_not have_content 'Question title'
        end
      end

      Capybara.using_session('user') do
        visit questions_path
        click_on 'Ask question'

        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Question body'
        click_on 'Ask'

        expect(current_path).to eq question_path(user.questions.last)
        expect(page).to have_content 'Question has been created successfully.'

        within '.question' do
          expect(page).to have_content 'Question title'
          expect(page).to have_content 'Question body'
        end
      end

      Capybara.using_session('another_user') do
        within '.questions' do
          expect(page).to_not have_content 'Question title'
        end
      end

      Capybara.using_session('guest') do
        within '.questions' do
          expect(page).to_not have_content 'Question title'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
