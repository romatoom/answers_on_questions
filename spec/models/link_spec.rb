require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'URL validator' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    it 'valid URL' do
      @link = question.links.new(name: 'Link', url: "https://google.com")
      expect(@link.valid?).to be true
    end

    context 'not valid URL' do
      it 'with url is htts://google.com' do
        @link = question.links.new(name: 'Link', url: "htts://google.com")
        expect(@link.valid?).to be false
      end

      it 'with url is google.com' do
        @link = question.links.new(name: 'Link', url: "google.com")
        expect(@link.valid?).to be false
      end

      it 'with url is https//google.com' do
        @link = question.links.new(name: 'Link', url: "https//google.com")
        expect(@link.valid?).to be false
      end
    end
  end

  describe 'match_gist method' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    it 'match link on gist resource' do
      @link = question.links.new(name: 'Gist link', url: "https://gist.github.com/romatoom/9640ae1653d1aac00e8ac9a0f7f0e166")
      match = @link.match_gist

      expect(match["nickname"]).to eq "romatoom"
      expect(match["gist_id"]).to eq "9640ae1653d1aac00e8ac9a0f7f0e166"
    end

    it 'match link on not gist resource' do
      @link = question.links.new(name: 'Not gist link', url: "https://google.com")
      match = @link.match_gist

      expect(match).to be_nil
    end
  end
end
