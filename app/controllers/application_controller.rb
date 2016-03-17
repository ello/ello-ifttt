class ApplicationController < ActionController::API

  rescue_from JWT::ExpiredSignature, with: :render_unauthorized
  rescue_from JWT::DecodeError, with: :render_invalid_token

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
    render json: { errors: [{ message: "Invalid or malformed JWT token" }] }, status: :unauthorized
  end

  def valid_channel_key?
    request.headers['IFTTT-Channel-Key'] == Rails.application.secrets.ifttt_channel_key
  end

  def validate_channel_key
    render_unauthorized unless valid_channel_key?
  end
end
