class ApplicationController < ActionController::API
  # rescue_from passes an optional parameter to the with: method
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

  private

  def not_found
    render json: { error: 'Record not found!' }, status: :not_found
  end

  def not_destroyed(err)
    render json: { errors: err.record.errors }, status: :unprocessable_entity
  end
end
