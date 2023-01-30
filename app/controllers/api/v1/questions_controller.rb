module Api
  module V1
    class QuestionsController < BaseController
      authorize_resource
      before_action :set_question, only: [:show, :update]

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionSerializer
      end

      def show
        render json: @question, serializer: QuestionSerializer
      end

      def create
        @question = Question.new(question_params.merge(author: current_user))

        if @question.save
          render json: @question, serializer: QuestionLiteSerializer
        else
          render_errors
        end
      end

      def update
        if @question.update(question_params)
          render json: @question, serializer: QuestionLiteSerializer
        else
          render_errors
        end
      end

      private

      def set_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(
          :title, :body,
          links_attributes: [:id, :name, :url, :_destroy]
        )
      end

      def render_errors
        render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
