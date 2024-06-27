# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RiskProfilesController, type: :controller do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe '#calculate_for_customer' do
    let(:perform_request) { post :calculate_for_customer, params:, as: :json }
    let(:customer) { build(:customer, :with_house, :with_vehicle, :with_risk_profile) }
    let(:params) do
      customer.as_json(except: %i[id created_at updated_at],
                       include: { house: { only: :ownership_status },
                                  vehicle: { only: :year } })
              .merge({ risk_questions: customer.risk_profile.risk_questions })
    end

    shared_examples 'a valid response' do
      it { should respond_with(:ok) }
      it 'returns a valid response with the expected keys' do
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(parsed_body).to have_key(:risk_profile)
        expect(parsed_body[:risk_profile]).to have_key(:auto)
        expect(parsed_body[:risk_profile]).to have_key(:disability)
        expect(parsed_body[:risk_profile]).to have_key(:home)
        expect(parsed_body[:risk_profile]).to have_key(:life)
      end
    end

    it {
      should permit(:age, :dependents, :income, :marital_status,
                    risk_questions: [], house: :ownership_status, vehicle: :year)
        .for(:calculate_for_customer, verb: :post, params:)
    }

    context 'with valid params' do
      before { perform_request }

      it_behaves_like 'a valid response'
    end
  end
end
