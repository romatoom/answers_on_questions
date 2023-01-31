shared_examples_for 'API fileable' do
  describe 'files' do
    it 'contains list of attached files' do
      expect(expecteable.size).to eq list_length
    end

    it 'returns filename and url' do
      %w[name url].each do |attr|
        expect(expecteable.first).to have_key(attr)
      end
    end
  end
end

