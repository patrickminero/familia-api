class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Pundit::Authorization

  include Devise::Controllers::Helpers

  before_action :authenticate_api_v1_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def render_json(data:, message:, errors: [], status: :ok)
    render json: { data: data, message: message, errors: errors }, status: status
  end

  def current_user
    current_api_v1_user
  end

  def user_not_authorized
    render_json(data: nil, message: "You are not authorized to perform this action", errors: ["unauthorized"],
                status: :forbidden)
  end
end
