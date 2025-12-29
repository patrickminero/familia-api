module Api
  module V1
    class SessionsController < Devise::SessionsController
      include JwtTokenHelper

      respond_to :json
      skip_before_action :authenticate_api_v1_user!, only: :create

      # rubocop:disable Metrics/MethodLength
      def create # rubocop:disable Metrics/AbcSize
        self.resource = User.find_for_database_authentication(email: params.dig(:user, :email))

        unless resource&.valid_password?(params.dig(:user, :password))
          return render_json(data: nil, message: "Invalid email or password.", errors: ["Invalid email or password."],
                             status: :unauthorized)
        end

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
          message: "Logged in successfully.",
          status: :ok
        )
      end
      # rubocop:enable Metrics/MethodLength

      def destroy
        token = jwt_token_from_header

        if token.present?
          if revoke_jwt(token)
            render_json(data: nil, message: "Logged out successfully.", status: :ok)
          else
            render_json(data: nil, message: "Invalid token.", errors: ["Invalid token."], status: :unauthorized)
          end
        else
          render_json(data: nil, message: "Couldn't find an active session.",
                      errors: ["Couldn't find an active session."], status: :unauthorized)
        end
      end

      private

      def auth_options
        { scope: resource_name, recall: "#{controller_path}#new" }
      end

      # Devise's `verify_signed_out_user` may short-circuit API logout requests
      # by rendering/redirecting when it thinks the user is already signed out.
      # For an API-only flow we handle JWT revocation explicitly in `destroy`,
      # so provide a no-op override to allow the action to run.
      def verify_signed_out_user # rubocop:disable Naming/PredicateMethod
        true
      end
    end
  end
end
