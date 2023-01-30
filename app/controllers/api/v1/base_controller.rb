module Api
  module V1
    class BaseController < ActionController::API
      include ActiveStorage::SetCurrent
      include CanCan::ControllerAdditions

      before_action :doorkeeper_authorize!

      check_authorization

      rescue_from CanCan::AccessDenied do |e|
        render json: errors_json(e.message), status: :forbidden
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: errors_json(e.message), status: :not_found
      end

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
        @current_user
      end

      def errors_json(messages)
        { errors: [*messages] }
      end
    end
  end
end
