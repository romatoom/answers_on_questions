require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'URL validator' do
    before(:each) do
      @user = User.create!(email: 'user@example.com', password: 'Password')
      @question = @user.questions.create!(title: 'Question title', body: 'Question body')

      it 'valid URL' do
        @link = @question.links.create!(name: 'Link', url: "https://google.com")
        expect(@link.valide?).to be_true
      end

      context 'not valid URL' do
        it 'with url is htts://google.com' do
          @link = @question.links.create!(name: 'Link', url: "https://google.com")
          expect(@link.valide?).to be_true
        end

        it 'with url is google.com' do
          @link = @question.links.create!(name: 'Link', url: "google.com")
          expect(@link.valide?).to be_false
        end

        it 'with url is http://googlecom' do
          @link = @question.links.create!(name: 'Link', url: "https://google.com")
          expect(@link.valide?).to be_false
        end
      end
    end
  end

  describe 'match_gist method' do
    before(:each) do
      @user = User.create!(email: 'user@example.com', password: 'Password')
      @question = @user.questions.create!(title: 'Question title', body: 'Question body')
    end

    it 'match link on gist resource' do
      @link = @question.links.create!(name: 'Gist link', url: "https://gist.github.com/romatoom/9640ae1653d1aac00e8ac9a0f7f0e166")
      match = @link.match_gist

      expect(match["nickname"]).to eq "romatoom"
      expect(match["gist_id"]).to eq "9640ae1653d1aac00e8ac9a0f7f0e166"
    end

    it 'match link on not gist resource' do
      @link = @question.links.create!(name: 'Not gist link', url: "https://google.com")
      match = @link.match_gist

      expect(match).to be_nil
    end
  end
end
