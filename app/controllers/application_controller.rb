class ApplicationController < ActionController::API

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

  def valid_channel_key?
    request.headers['IFTTT-Channel-Key'] == Rails.application.secrets.ifttt_channel_key
  end
end
