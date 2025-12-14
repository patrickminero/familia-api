module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :authenticate_api_v1_user!, only: :create

      def create
        user = User.new(sign_up_params)

        if user.save
          render_json(data: { id: user.id, email: user.email }, message: "User created", status: :created)
        else
          render_json(data: nil, message: "Failed to create user", errors: user.errors.full_messages,
                      status: :unprocessable_entity)
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     profile_attributes: %i[first_name last_name])
      end
    end
  end
end
