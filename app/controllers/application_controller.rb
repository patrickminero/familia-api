class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: {
      data: nil,
      message: "You are not authorized to perform this action",
      errors: ["unauthorized"]
    }, status: :forbidden
  end
end
