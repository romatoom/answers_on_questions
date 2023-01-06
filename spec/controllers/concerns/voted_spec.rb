require 'rails_helper'

shared_examples_for 'voted' do
  describe 'PATCH #like' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:voteable) { create(described_class.to_s.sub!('Controller', '').underscore.singularize.to_sym) }

    let!(:vote) { create(:vote, user: another_user, voteable: voteable) }

    subject(:like) do
      patch :like, params: {
        id: voteable.id,
        format: :json
      }
    end

    context 'when unauthorize user' do
      it 'response status unauthorized' do
        like
        expect(response.status).to eq 401
      end
    end

    context 'when authorize user' do
      before { login(user) }

      it 'response status ok' do
        like
        expect(response.status).to eq 200
      end

      it 'count votes increment by 1' do
        expect { like }.to change { voteable.reload.votes_sum }.from(1).to(2)
      end
    end
  end

  describe 'PATCH #dislike' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:voteable) { create(described_class.to_s.sub!('Controller', '').underscore.singularize.to_sym) }

    let!(:vote) { create(:vote, user: another_user, voteable: voteable, value: -1) }

    subject(:dislike) do
      patch :dislike, params: {
        id: voteable.id,
        format: :json
      }
    end

    context 'when unauthorize user' do
      it 'response status unauthorized' do
        dislike
        expect(response.status).to eq 401
      end
    end

    context 'when authorize user' do
      before { login(user) }

      it 'response status ok' do
        dislike
        expect(response.status).to eq 200
      end

      it 'count votes increment by 1' do
        expect { dislike }.to change { voteable.reload.votes_sum }.from(-1).to(-2)
      end
    end
  end

  describe 'PATCH #reset_vote' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:voteable) { create(described_class.to_s.sub!('Controller', '').underscore.singularize.to_sym) }

    let!(:vote) { create(:vote, user: user, voteable: voteable) }

    subject(:reset_vote) do
      patch :reset_vote, params: {
        id: voteable.id,
        format: :json
      }
    end

    context 'when unauthorize user' do
      it 'response status unauthorized' do
        reset_vote
        expect(response.status).to eq 401
      end
    end

    context 'when authorize user' do
      before { login(user) }

      it 'response status ok' do
        reset_vote
        expect(response.status).to eq 200
      end

      it 'count votes reset by 0' do
        expect { reset_vote }.to change { voteable.reload.votes_sum }.from(1).to(0)
      end
    end
  end
end
