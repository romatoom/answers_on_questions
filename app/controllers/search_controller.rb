class SearchController < ApplicationController
  authorize_resource :class => false

  def index
    @search_params = search_params
    @query = search_params['query'] || ''

    @results = SearchService.call(search_params)

    @results_count = @results.count
    @result_limit = SearchService::RESULT_LIMIT

    @results = @results.page(params[:page])

    #render json: @results, status: :found
  end

  private

  def search_params
    params.permit(:query, :search_questions, :search_answers, :search_users, :search_comments, :fuzziness)
  end
end

