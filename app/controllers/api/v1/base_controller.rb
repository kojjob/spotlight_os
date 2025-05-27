class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  before_action :authenticate_api_key

  private

  def authenticate_api_key
    api_key = request.headers["X-API-Key"]
    unless api_key.present? && valid_api_key?(api_key)
      render json: { error: "Invalid API key" }, status: :unauthorized
    end
  end

  def valid_api_key?(key)
    # For now, just check if it's present. In production, validate against stored keys
    key == "demo-api-key"
  end
end
