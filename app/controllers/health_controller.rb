class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def check
    render json: { status: 'ok', timestamp: Time.current }
  end
end
