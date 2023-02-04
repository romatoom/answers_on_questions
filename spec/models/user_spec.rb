require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:users_subscriptions).dependent(:destroy) }
  it { should have_many(:subscriptions).through(:users_subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#create_authorization' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1') }

    it 'create new authorization for user' do
      expect { user.create_authorization(auth) }.to change(user.authorizations, :count).by(1)
    end

    it 'create authorization with provider and uid' do
      authorization = user.create_authorization(auth)

      expect(authorization.provider).to eq auth.provider
      expect(authorization.uid).to eq auth.uid
    end
  end

  describe '#author_of?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }

    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, author: author) }

    context 'when author' do
      it 'of question' do
        expect(author.author_of?(question)).to be true
      end

      it 'of answer' do
        expect(author.author_of?(answer)).to be true
      end
    end

    context 'when not author' do
      it 'of question' do
        expect(not_author.author_of?(question)).to be false
      end

      it 'of answer' do
        expect(not_author.author_of?(answer)).to be false
      end
    end
  end

  describe '#like?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, author: author) }

    context 'when voteable not have user vote' do
      it 'user like question is nil' do
        expect(not_author.like?(question)).to be nil
      end

      it 'user like answer is nil' do
        expect(not_author.like?(answer)).to be nil
      end
    end

    context 'when voteable have user like' do
      before do
        create(:vote, user: not_author, voteable: question, value: 1)
        create(:vote, user: not_author, voteable: answer, value: 1)
      end

      it 'user like question' do
        expect(not_author.like?(question)).to be true
      end

      it 'user like answer' do
        expect(not_author.like?(answer)).to be true
      end
    end

    context 'when voteable have user dislike' do
      before do
        create(:vote, user: not_author, voteable: question, value: -1)
        create(:vote, user: not_author, voteable: answer, value: -1)
      end

      it 'user not like question' do
        expect(not_author.like?(question)).to be false
      end

      it 'user not like answer' do
        expect(not_author.like?(answer)).to be false
      end
    end
  end

  describe '#dislike?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, author: author) }

    context 'when voteable not have user vote' do
      it 'user dislike question is nil' do
        expect(not_author.dislike?(question)).to be nil
      end

      it 'user dislike answer is nil' do
        expect(not_author.dislike?(answer)).to be nil
      end
    end

    context 'when voteable have user dislike' do
      before do
        create(:vote, user: not_author, voteable: question, value: -1)
        create(:vote, user: not_author, voteable: answer, value: -1)
      end

      it 'user dislike question' do
        expect(not_author.dislike?(question)).to be true
      end

      it 'user dislike answer' do
        expect(not_author.dislike?(answer)).to be true
      end
    end

    context 'when voteable have user like' do
      before do
        create(:vote, user: not_author, voteable: question, value: 1)
        create(:vote, user: not_author, voteable: answer, value: 1)
      end

      it 'user not dislike question' do
        expect(not_author.dislike?(question)).to be false
      end

      it 'user not dislike answer' do
        expect(not_author.dislike?(answer)).to be false
      end
    end
  end
end
