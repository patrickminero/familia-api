module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_profile, only: %i[show update]

      def show
        render json: {
          data: ProfileSerializer.new(@profile).serializable_hash[:data][:attributes],
        }, status: :ok
      end

      def update
        if @profile.update(profile_params)
          render json: {
            data: ProfileSerializer.new(@profile).serializable_hash[:data][:attributes],
            message: "Profile updated successfully.",
          }, status: :ok
        else
          render json: {
            errors: @profile.errors.full_messages,
          }, status: :unprocessable_content
        end
      end

      private

      def set_profile
        @profile = current_user.profile
        return if @profile

        render json: {
          errors: ["Profile not found. Please create one first."],
        }, status: :not_found
      end

      def profile_params
        params.require(:profile).permit(:name, :phone, :timezone, :bio, notification_preferences: {},
                                                                        app_preferences: {})
      end
    end
  end
end
