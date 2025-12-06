module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        user = User.find_by(email: login_params[:email])

        if user&.valid_password?(login_params[:password])
          token = encode_token(user)
          render json: {
            token: token,
            data: UserSerializer.new(user).serializable_hash[:data][:attributes],
            message: "Logged in successfully.",
          }, status: :ok
        else
          render json: {
            errors: ["Invalid email or password."],
          }, status: :unauthorized
        end
      end

      def destroy
        if current_user
          jwt_payload = JWT.decode(token_from_header,
                                   Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base).first
          JwtDenylist.create!(jti: jwt_payload["jti"], exp: Time.at(jwt_payload["exp"]))

          render json: {
            message: "Logged out successfully.",
          }, status: :ok
        else
          render json: {
            errors: ["Couldn't find an active session."],
          }, status: :unauthorized
        end
      end

      private

      def login_params
        params.require(:user).permit(:email, :password)
      end

      def encode_token(user)
        payload = { user_id: user.id, exp: 30.days.from_now.to_i }
        JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base)
      end

      def token_from_header
        request.headers["Authorization"]&.split(" ")&.last
      end
    end
  end
end
