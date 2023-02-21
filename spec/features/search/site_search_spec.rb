require 'rails_helper'

feature 'User can use search', %q{
  In find interesting information by query
  As an any author
  I'd like to be able to search
} do
  background do
    visit root_path
    click_on 'Site search'
  end

  describe 'User can find only by question' do
    given!(:user1) { create(:user, email: 'test1@mail.ru') }
    given!(:user2) { create(:user, email: 'test2@mail.ru') }
    given!(:question1) { create(:question, title: 'You find me?') }
    given!(:question2) { create(:question, body: 'Yes. You find me again!') }
    given!(:answer) { create(:answer, body: 'You can not find me') }
    given!(:comment) { create(:comment, commenteable: answer, body: 'You can not find me') }

    scenario 'search success', elasticsearch: true, js: true do
      models_import

      find('#query').fill_in(with: 'Find me')

      find(:css, "#search_answers_chechbox").set(false)
      find(:css, "#search_users_chechbox").set(false)
      find(:css, "#search_comments_chechbox").set(false)

      click_on 'Search'

      within '.result_count' do
        expect(page).to have_content ("2")
      end

      type_labels = page.all(".type-label")
      expect(type_labels.length).to eq 2
      type_labels.each { |l| expect(l.text).to eq 'QUESTION' }
    end
  end

  describe 'User can find only by answer' do
    given!(:user1) { create(:user, email: 'test1@mail.ru') }
    given!(:user2) { create(:user, email: 'test2@mail.ru') }
    given!(:answer1) { create(:answer, body: 'Try find me') }
    given!(:answer2) { create(:answer, body: 'Try find me again!') }
    given!(:question1) { create(:question, body: 'You can not find me') }
    given!(:question2) { create(:question, title: 'You can not find me') }
    given!(:comment) { create(:comment, commenteable: question1, body: 'You can not find me') }

    scenario 'search success', elasticsearch: true, js: true do
      models_import

      find('#query').fill_in(with: 'Find me')

      find(:css, "#search_questions_chechbox").set(false)
      find(:css, "#search_users_chechbox").set(false)
      find(:css, "#search_comments_chechbox").set(false)

      click_on 'Search'

      within '.result_count' do
        expect(page).to have_content ("2")
      end

      type_labels = page.all(".type-label")
      expect(type_labels.length).to eq 2
      type_labels.each { |l| expect(l.text).to eq 'ANSWER' }
    end
  end

  describe 'User can find only by user' do
    given!(:user1) { create(:user, email: 'test1@mail.ru') }
    given!(:user2) { create(:user, email: 'test2@mail.ru') }
    given!(:answer) { create(:answer, body: 'You can not find me') }
    given!(:question1) { create(:question, body: 'You can not find me') }
    given!(:question2) { create(:question, title: 'You can not find me') }
    given!(:comment) { create(:comment, commenteable: question1, body: 'You can not find me') }

    scenario 'search success', elasticsearch: true, js: true do
      models_import

      find('#query').fill_in(with: 'test1@mail.ru')

      find(:css, "#search_questions_chechbox").set(false)
      find(:css, "#search_answers_chechbox").set(false)
      find(:css, "#search_comments_chechbox").set(false)

      click_on 'Search'

      within '.result_count' do
        expect(page).to have_content ("1")
      end

      type_labels = page.all(".type-label")
      expect(type_labels.length).to eq 1
      type_labels.each { |l| expect(l.text).to eq 'USER' }
    end
  end

  describe 'User can find only by comment' do
    given!(:user1) { create(:user, email: 'test1@mail.ru') }
    given!(:user2) { create(:user, email: 'test2@mail.ru') }
    given!(:answer) { create(:answer, body: 'You can not find me') }
    given!(:question1) { create(:question, body: 'You can not find me') }
    given!(:question2) { create(:question, title: 'You can not find me') }
    given!(:comment1) { create(:comment, commenteable: question1, body: 'Try find me') }
    given!(:comment2) { create(:comment, commenteable: question2, body: 'Try find me again!') }

    scenario 'search success', elasticsearch: true, js: true do
      models_import

      find('#query').fill_in(with: 'Find me')

      find(:css, "#search_questions_chechbox").set(false)
      find(:css, "#search_answers_chechbox").set(false)
      find(:css, "#search_users_chechbox").set(false)

      click_on 'Search'

      within '.result_count' do
        expect(page).to have_content ("2")
      end

      type_labels = page.all(".type-label")
      expect(type_labels.length).to eq 2
      type_labels.each { |l| expect(l.text).to match(/COMMENT/) }
    end
  end

  describe 'User can find by all' do
    given!(:user1) { create(:user, email: 'test1@mail.ru') }
    given!(:user2) { create(:user, email: 'test2@mail.ru') }
    given!(:answer) { create(:answer, body: 'Try find me 1') }
    given!(:question1) { create(:question, body: 'Try find me 2') }
    given!(:question2) { create(:question, title: 'Try find me 3') }
    given!(:comment1) { create(:comment, commenteable: question1, body: 'Try find me 4') }
    given!(:comment2) { create(:comment, commenteable: question2, body: 'Try find me again 5') }

    scenario 'search success', elasticsearch: true, js: true do
      models_import

      find('#query').fill_in(with: 'Find me')

      click_on 'Search'

      within '.result_count' do
        expect(page).to have_content ("5")
      end

      expect(page.all(".type-label").length).to eq 5
    end
  end

end

