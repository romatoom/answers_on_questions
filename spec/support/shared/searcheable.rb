shared_examples_for 'searcheable' do
  describe 'check' do
    before do
      models_import
    end

    it 'call SearchService', elasticsearch: true do
      search_params = ActionController::Parameters.new(params).permit!
      expect(SearchService).to receive(:call).with(search_params).and_call_original
      perform(params)
    end

    it 'returns the required number of results', elasticsearch: true do
      perform(params)
      expect(assigns(:results).count).to eq count_results
    end

    it 'renders new view', elasticsearch: true do
      perform(params)
      expect(response).to render_template :index
    end
  end
end

