shared_examples_for 'API linkeable' do
  describe 'links' do
    it 'contains list of attached files' do
      expect(expecteable.size).to eq list_length
    end

    it 'returns id, name and url' do
      %w[id name url].each do |attr|
        expect(expecteable.first).to have_key(attr)
      end
    end
  end
end

