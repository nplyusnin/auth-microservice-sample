# frozen_string_literal: true

class AuthRoutes < Application
  AUTH_TOKEN = /\ABearer (?<token>.+)\z/.freeze

  post '/' do
    result = Auth::FetchUserService.call(extracted_token['uuid'])

    if result.success?
      status 200
      json meta: { user_id: result.user.id }
    else
      status 422
      error_response(result.errors)
    end
  end

  def extracted_token
    JwtEncoder.decode(matched_token)
  rescue JWT::DecodeError
    {}
  end

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_header
    request.env['HTTP_AUTHORIZATION']
  end
end
