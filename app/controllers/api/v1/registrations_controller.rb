module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include JwtTokenHelper

      respond_to :json
      skip_before_action :authenticate_api_v1_user!, only: :create

      # rubocop:disable Metrics/MethodLength
      def create # rubocop:disable Metrics/AbcSize
        build_resource(sign_up_params)

        if resource.save
          sign_in(resource_name, resource, store: false)

          token = jwt_token_from_env_or_header
          expires_at = jwt_exp_from_token(token)

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
    end
  end
end
