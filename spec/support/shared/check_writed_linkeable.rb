shared_examples_for 'API create/update linkeable' do
  it 'returns public fields' do
    fields.each do |attr|
      expect(expectable[attr]).to eq received.send(attr).as_json
    end
  end

  describe 'return links' do
    it 'returns list of links' do
      expect(expectable['list_of_links'].size).to eq count_of_links
    end

    it 'returns name and url for link' do
      %w[name url].each do |attr|
        expect(expectable['list_of_links'].first[attr]).to eq links_attributes.first[attr.to_sym]
      end
    end
  end
end

