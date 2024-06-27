# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::RiskProfiles', type: :request do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe 'POST /calculate_for_customer' do
    subject { post v1_risk_profiles_calculate_for_customer_path, params:, as: :json }

    let(:customer) { build(:customer, :with_house, :with_vehicle, :with_risk_profile) }
    let(:risk_questions) { customer.risk_profile.risk_questions }
    let(:params) do
      customer.as_json(except: %i[id created_at updated_at],
                       include: { house: { only: :ownership_status },
                                  vehicle: { only: :year } })
              .merge({ risk_questions: })
    end

    before { subject }

    shared_examples 'a valid response' do
      it 'returns a valid response with the expected keys' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(parsed_body).to have_key(:risk_profile)
        expect(parsed_body[:risk_profile]).to have_key(:auto)
        expect(parsed_body[:risk_profile]).to have_key(:disability)
        expect(parsed_body[:risk_profile]).to have_key(:home)
        expect(parsed_body[:risk_profile]).to have_key(:life)
      end
    end

    shared_examples 'expected risk score tiers' do |expected_risk_score_tier|
      it 'returns a valid response with the expected risk score tiers' do
        expect(parsed_body.dig(:risk_profile, :auto)).to eq(expected_risk_score_tier)
        expect(parsed_body.dig(:risk_profile, :disability)).to eq(expected_risk_score_tier)
        expect(parsed_body.dig(:risk_profile, :home)).to eq(expected_risk_score_tier)
        expect(parsed_body.dig(:risk_profile, :life)).to eq(expected_risk_score_tier)
      end
    end

    shared_examples 'a response with a specific error' do |status, error, message|
      it "returns a response with status '#{status}', error '#{error}' and message '#{message}'" do
        expect(response).to have_http_status(status)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(parsed_body[:status]).to eq status
        expect(parsed_body[:error]).to eq error
        expect(parsed_body[:exception]).to include(message)
      end
    end

    context 'with valid parameters' do
      it_behaves_like 'a valid response'

      context 'with attributes that do NOT trigger any risk score change' do
        let(:customer) { build(:customer, :static) }

        it_behaves_like 'a valid response'
        it_behaves_like 'expected risk score tiers', 'padrao'

        context "with 'economico' risk score'" do
          let(:risk_questions) { [false, false, false] }
          it_behaves_like 'expected risk score tiers', 'economico'
        end

        context "with 'avancado' risk score'" do
          let(:risk_questions) { [true, true, true] }
          it_behaves_like 'expected risk score tiers', 'avancado'
        end
      end
    end

    context 'with invalid parameters' do
      context 'age' do
        let(:customer) { build(:customer, :with_risk_profile, age: -1) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        'Age must be greater than or equal to 0'
      end

      context 'dependents' do
        let(:customer) { build(:customer, :with_risk_profile, dependents: -1) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        'Dependents must be greater than or equal to 0'
      end

      pending "house's ownership status"

      context 'income' do
        let(:customer) { build(:customer, :with_risk_profile, income: -1) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        'Income must be greater than or equal to 0'
      end

      pending 'marital status'

      context 'risk questions' do
        let(:risk_profile) { build(:risk_profile, risk_questions: %i[no yes no]) }
        let(:customer) { build(:customer, :with_risk_profile, risk_profile:) }
        it_behaves_like 'a valid response'
      end

      context 'vehicle' do
        let(:vehicle) { build(:vehicle, year: Time.current.year + 1) }
        let(:customer) { build(:customer, :with_risk_profile, vehicle:) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        "Year must be less than or equal to #{Time.current.year}"
      end
    end

    context 'without attributes' do
      context 'age' do
        let(:customer) { build(:customer, :with_risk_profile, age: nil) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        "Age can't be blank, Age is not a number"
      end

      context 'dependents' do
        let(:customer) { build(:customer, :with_risk_profile, dependents: nil) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        "Dependents can't be blank, Dependents is not a number"
      end

      context 'house' do
        let(:customer) { build(:customer, :with_risk_profile) }
        it_behaves_like 'a valid response'
      end

      context 'income' do
        let(:customer) { build(:customer, :with_risk_profile, income: nil) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        "Income can't be blank, Income is not a number"
      end

      context 'marital status' do
        let(:customer) { build(:customer, :with_risk_profile, marital_status: nil) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        "Marital status can't be blank"
      end

      context 'risk questions' do
        let(:risk_profile) { build(:risk_profile, risk_questions: nil) }
        let(:customer) { build(:customer, :with_risk_profile, risk_profile:) }
        it_behaves_like 'a response with a specific error', 422, 'Unprocessable Content',
                        "Risk questions can't be blank"
      end

      context 'vehicle' do
        let(:customer) { build(:customer, :with_risk_profile) }

        it_behaves_like 'a valid response'
      end
    end
  end
end
