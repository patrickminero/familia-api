module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_api_v1_user!, only: [:create]

      def create
        user = User.find_by(email: login_params[:email])

        if user&.valid_password?(login_params[:password])
          token = Jwt::TokenGenerator.call(user)
          data = UserSerializer.new(user).serializable_hash[:data][:attributes]
          data_with_token = data.merge(token: token)
          render_json(data: data_with_token, message: "Logged in successfully.")
        else
          render_json(data: nil, message: "Invalid email or password.", errors: ["unauthorized"], status: :unauthorized)
        end
      end

      def destroy
        if current_user
          jwt_payload = JWT.decode(token_from_header,
                                   Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base).first
          JwtDenylist.create!(jti: jwt_payload["jti"], exp: Time.zone.at(jwt_payload["exp"]))
          render_json(data: nil, message: "Logged out successfully.")
        else
          render_json(data: nil, message: "Couldn't find an active session.", errors: ["unauthorized"],
                      status: :unauthorized)
        end
      end

      private

      def login_params
        params.require(:user).permit(:email, :password)
      end

      def token_from_header
        request.headers["Authorization"]&.split&.last
      end
    end
  end
end
