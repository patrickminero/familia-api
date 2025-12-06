class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    begin
      decoded = JWT.decode(token,
                           Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base, true, { algorithm: "HS256" })
      @current_user = User.find(decoded.first["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end
  end

  attr_reader :current_user

  def user_not_authorized
    render json: {
      data: nil,
      message: "You are not authorized to perform this action",
      errors: ["unauthorized"],
    }, status: :forbidden
  end
end
