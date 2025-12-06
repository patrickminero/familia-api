module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        user = User.new(sign_up_params)

        if user.save
          user.reload # Ensure profile association is loaded
          token = encode_token(user)
          render json: {
            token: token,
            data: UserSerializer.new(user).serializable_hash[:data][:attributes],
            message: "Signed up successfully.",
          }, status: :created
        else
          render json: {
            errors: user.errors.full_messages,
          }, status: :unprocessable_content
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     profile_attributes: %i[name phone timezone bio])
      end

      def encode_token(user)
        payload = { user_id: user.id, exp: 30.days.from_now.to_i }
        JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base)
      end
    end
  end
end
