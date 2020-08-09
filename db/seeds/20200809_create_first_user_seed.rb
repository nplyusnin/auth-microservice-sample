# frozen_string_literal: true

Sequel.seed do
  def run
    User.create(
      name: 'Bob',
      email: 'bob@example.com',
      password: 'password'
    )
  end
end
