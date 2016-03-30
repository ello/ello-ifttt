class ApplicationController < ActionController::API

  rescue_from JWT::DecodeError, with: :render_invalid_token
  rescue_from JWT::ExpiredSignature, with: :render_unauthorized

  private

  def bearer_token
    request.authorization.split.last
  end

  def jwt_token
    @jwt_token ||= begin
                     JWT.decode bearer_token, OpenSSL::PKey::RSA.new(ENV['JWT_PUBLIC_KEY']), true, { :algorithm => 'RS512' }
                   end
  end

  def jwt_header
    jwt_token.last
  end

  def jwt_payload
    jwt_token.first
  end

  def render_unauthorized
    head :unauthorized
  end

  def render_invalid_token
    render json: { errors: [{ message: 'Invalid or malformed JWT token' }] }, status: :unauthorized
  end

  def valid_channel_key?
    request.headers['IFTTT-Channel-Key'] == Rails.application.secrets.ifttt_channel_key
  end

  def validate_channel_key
    render_unauthorized unless valid_channel_key?
  end

  def user_id
    jwt_payload['data']['id'].to_s
  end

  def current_registered_user
    @current_registered_user ||= RegisteredUser.find_by(user_id: user_id)
  end

  def require_registered_user
    render_unauthorized unless current_registered_user
  end
end
