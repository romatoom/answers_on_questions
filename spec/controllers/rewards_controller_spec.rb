require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
=begin
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end
=end
end
