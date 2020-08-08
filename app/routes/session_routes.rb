# frozen_string_literal: true

class SessionRoutes < Application
  namespace '/v1' do
    post do
      session_params = validate_with!(UserSessionParamsContract)

      result = UserSessions::CreateService.call(
        session_params[:email],
        session_params[:password]
      )

      if result.success?
        token = JwtEncoder.encode(uuid: result.session.uuid)
        meta = { token: token }

        status 201
        json meta: meta
      else
        status 422
        error_response result.errors
      end
    end
  end
end
