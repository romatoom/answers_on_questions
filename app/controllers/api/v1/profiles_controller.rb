module Api
  module V1
    class ProfilesController < BaseController
      authorize_resource :class => false

      def me
        render json: current_user
      end
    end
  end
end
