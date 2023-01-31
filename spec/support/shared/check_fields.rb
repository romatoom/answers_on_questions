shared_examples_for 'API fields checkable' do
  it 'returns specified fields' do
    existing_fields.each do |attr|
      expect(expectable[attr]).to eq received.send(attr).as_json
    end
  end

  it 'does not returns specified fields' do
    not_existing_fields.each do |attr|
      expect(expectable).to_not have_key(attr)
    end
  end
end
