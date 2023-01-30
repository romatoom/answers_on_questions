module Api
  module V1
    class AnswersController < BaseController
      authorize_resource

      def index
        @answers = Question.find(params[:question_id]).answers
        render json: @answers, each_serializer: AnswersSerializer
      end

      def show
        @answer = Answer.find(params[:id])
        render json: @answer, serializer: AnswerSerializer
      end
    end
  end
end
