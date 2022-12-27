require 'rails_helper'

feature 'The user can view the list of his rewards', %q(
  In order to view a rewards
  As a any user
  I would like to be able to view the list of rewards
) do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question1) { create(:question, author: author) }
  given!(:question2) { create(:question, author: author) }

  given(:link_to_default_image) { "#{Rails.root}/spec/files_for_active_storage/reward.png" }

  background do
    create(:reward,
      title: 'Reward 1',
      image: Rack::Test::UploadedFile.new(link_to_default_image),
      user: user,
      question: question1
    )

    create(:reward,
      title: 'Reward 2',
      image: Rack::Test::UploadedFile.new(link_to_default_image),
      user: user,
      question: question2
    )

    sign_in(user)
  end

  scenario 'Authorized user can view the list of questions' do
    visit rewards_path

    user.rewards.each do |reward|
      expect(page).to have_content reward.title
      expect(page).to have_css("img[src*='#{reward.image.filename}']")
      expect(page).to have_content reward.question.title
    end
  end
end
