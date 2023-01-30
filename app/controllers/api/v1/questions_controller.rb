module Api
  module V1
    class QuestionsController < BaseController
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionSerializer
      end

      def show
        @question = Question.find(params[:id])
        render json: @question, serializer: QuestionSerializer
      end

      def create
        @question = Question.new(question_params.merge(author: current_user))

        if @question.save
          render json: @question, serializer: QuestionLiteSerializer
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def question_params
        params.require(:question).permit(
          :title, :body,
          links_attributes: [:id, :name, :url, :_destroy],
          reward_attributes: [:id, :title, :image, :_destroy]
        )
      end
    end
  end
end
