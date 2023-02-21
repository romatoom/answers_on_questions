require 'rails_helper'

RSpec.describe SearchService do
  let!(:search_params) do
    ActionController::Parameters.new({
      query: "Sample of query",
      search_questions: "1",
      search_answers: "1",
      search_users: "1",
      search_comments: "1"
    }).permit!
  end

  subject { SearchService.new(search_params) }

  it 'call Elasticsearch::Model.search with correct params', elasticsearch: true do
    expect(Elasticsearch::Model).to receive(:search).with(subject.search_settings, subject.models_for_search)
    SearchService.call(search_params)
  end
end
