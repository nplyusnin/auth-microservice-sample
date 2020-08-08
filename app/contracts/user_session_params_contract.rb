# frozen_string_literal: true

class UserSessionParamsContract < Dry::Validation::Contract
  params do
    required(:email).value(:string)
    required(:password).value(:string)
  end
end
