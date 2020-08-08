# frozen_string_literal: true

class UserRoutes < Application
  namespace '/v1' do
    post do
      user_params = validate_with!(UserParamsContract)

      result = Users::CreateService.call(
        user_params[:name],
        user_params[:email],
        user_params[:password]
      )

      if result.success?
        status 201
        json data: nil
      else
        status 422
        error_response result.user
      end
    end
  end
end
