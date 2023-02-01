module Api
  module V1
    class ProfilesController < BaseController
      authorize_resource :class => false

      def me
        render json: current_user, serializer: UserSerializer
      end

      def others
        @other_profiles = User.where.not(id: current_user.id)
        render json: @other_profiles, each_serializer: UserSerializer
      end
    end
  end
end
