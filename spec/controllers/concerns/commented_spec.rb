require 'rails_helper'

shared_examples_for 'commented' do
  describe 'PATCH #add_comment' do
    let!(:user) { create(:user) }
    let!(:commenteable_type) { described_class.to_s.sub!('Controller', '').singularize }
    let!(:commenteable) { create(commenteable_type.underscore.to_sym) }

    subject(:add_comment) do
      patch :add_comment, params: {
        id: commenteable.id,
        body: 'Comment body',
        format: :json
      }
    end

    context 'when unauthorize user' do
      it 'response status unauthorized' do
        add_comment
        expect(response.status).to eq 401
      end
    end

    context 'when authorize user' do
      before { login(user) }

      it 'response status ok' do
        add_comment
        expect(response.status).to eq 200
      end

      it 'add comment to commenteable' do
        add_comment

        last_comment = commenteable.reload.comments.last
        expect(last_comment.body).to eq 'Comment body'
        expect(last_comment.commenteable_type).to eq commenteable_type
        expect(last_comment.commenteable_id).to eq commenteable.id
      end

      it 'increment comments count to commenteable' do
        expect { add_comment }.to change { commenteable.reload.comments.length }.by(1)
      end
    end
  end
end
