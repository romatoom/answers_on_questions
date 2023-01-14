require 'rails_helper'

shared_examples_for 'commented' do
  describe 'PATCH #add_comment' do
=begin
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:commenteable) { create(described_class.to_s.sub!('Controller', '').underscore.singularize.to_sym) }

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
    end
=end
  end
end
