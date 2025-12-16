require_relative "../../../services/users/register_service"
require_relative "../../../services/jwt/token_generator"

module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :authenticate_api_v1_user!, only: :create

      def create
        result = Users::RegisterService.new(sign_up_params).call

        if result[:user]
          token = Jwt::TokenGenerator.call(result[:user])
          render json: {
            token: token,
            data: UserSerializer.new(result[:user]).serializable_hash[:data][:attributes],
            message: "User created",
          }, status: :created
        else
          render_json(data: nil, message: "Failed to create user", errors: result[:errors] || [],
                      status: :unprocessable_entity)
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          profile_attributes: [
            :name,
            :phone,
            :timezone,
            :bio,
            { notification_preferences: {} },
            { app_preferences: {} },
          ]
        )
      end
    end
  end
end
