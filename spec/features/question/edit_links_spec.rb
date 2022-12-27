require 'rails_helper'

feature 'User can edit, add, delete links of his question', %q{
  In edit links in my question
  As an question's author
  I'd like to be able to edit, add, remove links
} do
  given!(:user) { create(:user) }

  given(:url_google) { 'https://google.com' }
  given(:url_dzen) { 'https://dzen.ru' }

  given(:link_google) { attributes_for(:link, name: 'Google link', url: url_google) }
  given(:link_dzen) { attributes_for(:link, name: 'Dzen link', url: url_dzen) }

  given!(:question) { create(:question, links_attributes: [link_google, link_dzen], author: user) }

  given(:url_vk) { 'https://vk.com' }
  given(:url_github) { 'https://github.com'}

  background do
    sign_in(user)
    visit questions_path

    click_on 'Edit'
  end

  scenario 'User edit link when edit question', js: true do
    within all(".nested-fields").first do
      fill_in 'Link name', with: 'VK link'
      fill_in 'URL', with: url_vk
    end

    click_on 'Save'

    expect(page).to have_link 'VK link', href: url_vk
    expect(page).to have_link 'Dzen link', href: url_dzen
  end

  scenario 'User add new links when edit question', js: true do
    click_on '+ Add link'

    within all(".nested-fields").last do
      fill_in 'Link name', with: 'VK link'
      fill_in 'URL', with: url_vk
    end

    click_on '+ Add link'

    within all(".nested-fields").last do
      fill_in 'Link name', with: 'GitHub link'
      fill_in 'URL', with: url_github
    end

    click_on 'Save'

    expect(page).to have_link 'Google link', href: url_google
    expect(page).to have_link 'Dzen link', href: url_dzen
    expect(page).to have_link 'VK link', href: url_vk
    expect(page).to have_link 'GitHub link', href: url_github
  end

  scenario 'User remove link when edit question', js: true do
    expect(page).to have_link 'Google link', href: url_google
    expect(page).to have_link 'Dzen link', href: url_dzen

    within all(".nested-fields").first do
      find('.remove-resource-link-item').click
    end

    within all(".nested-fields").first do
      find('.remove-resource-link-item').click
    end

    click_on 'Save'

    expect(page).to_not have_link 'Google link', href: url_google
    expect(page).to_not have_link 'Dzen link', href: url_dzen
  end
end
