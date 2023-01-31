shared_examples_for 'API commentable' do
  describe 'comments' do
    it 'returns list of comments' do
      expect(expecteable.size).to eq 3
    end

    it 'returns fields for comment' do
      %w[id body created_at updated_at].each do |attr|
        expect(expecteable.first[attr]).to eq received.first.send(attr).as_json
      end
    end

    it 'contains author of comment (user object)' do
      %w[id email admin created_at updated_at].each do |attr|
        expect(expecteable.first['author'][attr]).to eq received.first.author.send(attr).as_json
      end
    end
  end
end

