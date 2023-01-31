module Api
  module V1
    class AnswersController < BaseController
      authorize_resource

      before_action :set_question, only: [:index, :create]
      before_action :set_answer, only: [:show, :update, :destroy]

      def index
        @answers = @question.answers
        render json: @answers, each_serializer: AnswersSerializer
      end

      def show
        render json: @answer, serializer: AnswerSerializer
      end

      def create
        @answer = @question.answers.new(answer_params.merge(author: current_user))

        if @answer.save
          render json: @answer, serializer: AnswerLiteSerializer
        else
          render_errors
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer, serializer: AnswerLiteSerializer
        else
          render_errors
        end
      end

      def destroy
        @answer.destroy
        render json: @answer, serializer: AnswerLiteSerializer
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
      end

      def set_answer
        @answer = Answer.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy])
      end

      def render_errors
        render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
