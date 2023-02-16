class SearchController < ApplicationController
  authorize_resource :class => false

  def index
    query = params['query'] || ''
    result = Question.search(query)
    @results = result.response["hits"]["hits"]
  end
end
