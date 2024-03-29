require 'rails_helper'

feature 'User can subscribe to notifications', %q(
  In order follow the changes
  As an authenticated user
  I would like to be able to subscribe to notifications
) do
  include ActiveJob::TestHelper

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    describe 'subscription for new answers' do
      let!(:subscription) { create(:subscription, :new_answer, id: 1) }
      background { visit question_path(question) }

      context 'when user not have subscribe' do
        scenario 'can subscribed', js: true do
          expect(page).to_not have_content 'Unwatch for new answers'
          click_on 'Watch for new answers'

          within '.alerts' do
            expect(page).to have_content "You have subscribed to be '#{subscription.title}' subscription."
          end
        end

        scenario 'not send email after create new answer', js: true do
          fill_in 'You can answer the question here', with: 'New answer body'
          click_on 'Answer'

          sleep 0.1

          within '.alerts' do
            expect(page).to have_content 'Answer has been created successfully.'
          end

          # for NewAnswerJob
          perform_enqueued_jobs

          # for Mailers
          perform_enqueued_jobs

          expect(all_emails.count).to be 0
        end
      end

      context 'when users have subscribe' do
        background do
          create(:users_subscription, user: user, subscription: subscription, question: question)
          create(:users_subscription, user: other_user, subscription: subscription, question: question)
        end

        scenario 'can unsubscribed', js: true do
          visit question_path(question)

          expect(page).to_not have_content 'Watch for new answers'
          click_on 'Unwatch for new answers'

          within '.alerts' do
            expect(page).to have_content "You have unsubscribed to be '#{subscription.title}' subscription."
          end
        end

        scenario 'send email after create new answer', js: true do
          fill_in 'You can answer the question here', with: 'New answer body'
          click_on 'Answer'

          sleep 0.1

          within '.alerts' do
            expect(page).to have_content 'Answer has been created successfully.'
          end

          # for NewAnswerJob
          perform_enqueued_jobs

          # for Mailers
          perform_enqueued_jobs

          expect(all_emails.count).to be 2

          open_email(user.email)
          expect(current_email.subject).to eq 'New answer'

          open_email(other_user.email)
          expect(current_email.subject).to eq 'New answer'
        end
      end
    end

    describe 'subscription for update question' do
      let!(:subscription) { create(:subscription, :change_question, id: 1) }

      context 'when user not have subscribe' do
        scenario 'can subscribed', js: true do
          visit question_path(question)

          expect(page).to_not have_content 'Unwatch for update question'
          click_on 'Watch for update question'

          within '.alerts' do
            expect(page).to have_content "You have subscribed to be '#{subscription.title}' subscription."
          end
        end

        scenario 'not send email after update question', js: true do
          visit questions_path

          click_on 'Edit'
          fill_in 'Title', with: 'New question title'
          click_on 'Save'

          sleep 0.1

          within '.alerts' do
            expect(page).to have_content 'Question has been edited successfully.'
          end

          # for NewAnswerJob
          perform_enqueued_jobs

          # for Mailers
          perform_enqueued_jobs

          expect(all_emails.count).to be 0
        end
      end

      context 'when users have subscribe' do
        background do
          create(:users_subscription, user: user, subscription: subscription, question: question)
          create(:users_subscription, user: other_user, subscription: subscription, question: question)
        end

        scenario 'can unsubscribed', js: true do
          visit question_path(question)

          expect(page).to_not have_content 'Watch for update question'
          click_on 'Unwatch for update question'

          within '.alerts' do
            expect(page).to have_content "You have unsubscribed to be '#{subscription.title}' subscription."
          end
        end

        scenario 'send email after update question', js: true do
          visit questions_path

          click_on 'Edit'
          fill_in 'Title', with: 'New question title'
          click_on 'Save'

          sleep 0.1

          within '.alerts' do
            expect(page).to have_content 'Question has been edited successfully.'
          end

          # for NewAnswerJob
          perform_enqueued_jobs

          # for Mailers
          perform_enqueued_jobs

          expect(all_emails.count).to be 2

          open_email(user.email)
          expect(current_email.subject).to eq 'Question changed'

          open_email(other_user.email)
          expect(current_email.subject).to eq 'Question changed'
        end
      end
    end
  end

  scenario "Unuthenticated user can't subscribe/unsubscribe", js: true do
    visit question_path(question)

    expect(page).to_not have_content('Watch for new answers')
    expect(page).to_not have_content('Unwatch for new answers')
    expect(page).to_not have_content('Watch for update question')
    expect(page).to_not have_content('Unwatch for update question')
  end
end
