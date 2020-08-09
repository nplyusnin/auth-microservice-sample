# frozen_string_literal: true

RSpec.describe AuthRoutes, type: :routes do
  describe 'POST /' do
    context 'invalid token' do
      it 'returns an error' do
        post '/', {}, { 'Authorization' => 'Bearer invalid' }

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'Доступ к ресурсу ограничен')
      end
    end

    context 'session not found' do
      let(:token) { JwtEncoder.encode(uuid: SecureRandom.uuid) }

      it 'returns created status' do
        post '/', {}, { 'Authorization' => "Bearer #{token}" }

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'Доступ к ресурсу ограничен')
      end
    end

    context 'valid parameters' do
      let!(:session) { create(:user_session, uuid: SecureRandom.uuid) }
      let(:token) { JwtEncoder.encode(uuid: session.uuid) }

      it 'returns success status' do
        post '/', {}, { 'Authorization' => "Bearer #{token}" }

        expect(last_response.status).to eq(200)
      end

      it 'returns success status' do
        post '/', {}, { 'Authorization' => "Bearer #{token}" }

        expect(response_body['meta']).to eq('user_id' => session.user.id)
      end
    end
  end
end
