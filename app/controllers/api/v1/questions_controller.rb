module Api
  module V1
    class QuestionsController < BaseController
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end
    end
  end
end
