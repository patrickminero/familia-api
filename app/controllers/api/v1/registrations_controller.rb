module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      skip_before_action :authenticate_api_v1_user!, only: :create

      # rubocop:disable Metrics/MethodLength
      def create # rubocop:disable Metrics/AbcSize
        build_resource(sign_up_params)

        if resource.save
          sign_in(resource_name, resource, store: false)

          token = extract_jwt_token
          expires_at = decode_jwt_exp(token)

          render_json(
            data: {
              user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
              token: token,
              token_type: "Bearer",
              expires_at: expires_at,
            },
            message: "User created",
            status: :created
          )
        else
          render_json(data: nil, message: "Failed to create user", errors: resource.errors.full_messages,
                      status: :unprocessable_entity)
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     profile_attributes: %i[name timezone bio phone])
      end

      def extract_jwt_token
        token = request.env["warden-jwt_auth.token"] || response.headers["Authorization"]&.split&.last
        return nil unless token

        token.to_s.start_with?("Bearer ") ? token.split.last : token
      end

      def decode_jwt_exp(token)
        return nil unless token

        begin
          payload = JWT.decode(token, ENV.fetch("DEVISE_JWT_SECRET_KEY") do
            Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base
          end).first
          Time.at(payload["exp"]).utc.iso8601 if payload && payload["exp"]
        rescue JWT::DecodeError
          nil
        end
      end
    end
  end
end
