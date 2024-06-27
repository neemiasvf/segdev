# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::CalculateRiskProfileForCustomer, type: :use_case do
  subject { described_class.call!(params) }

  let(:customer) { build(:customer, :with_house, :with_vehicle, :with_risk_profile) }
  let(:params) do
    customer.as_json(except: %i[id created_at updated_at],
                     include: { house: { only: :ownership_status },
                                vehicle: { only: :year } })
            .merge({ risk_questions: customer.risk_profile.risk_questions })
  end

  shared_examples 'a valid risk profile' do
    it 'returns a valid risk profile, with calculated risk scores' do
      expect(subject).to be_a(RiskProfile)
      expect(subject).to be_valid
    end
  end

  shared_examples 'an exception' do |exception, message|
    it "raises exception '#{exception}' with message '#{message}'" do
      expect { subject }.to raise_error(exception, message)
    end
  end

  context 'with valid attributes' do
    it_behaves_like 'a valid risk profile'
  end

  context 'with invalid attributes' do
    context 'age' do
      let(:customer) { build(:customer, :with_risk_profile, age: -1) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      'Validation failed: Age must be greater than or equal to 0'
    end

    context 'dependents' do
      let(:customer) { build(:customer, :with_risk_profile, dependents: -1) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      'Validation failed: Dependents must be greater than or equal to 0'
    end

    context 'house' do
      let(:house) { build(:house, ownership_status: :invalid_status) }
      let(:customer) { build(:customer, :with_risk_profile, house:) }
      it_behaves_like 'an exception', ArgumentError, "'invalid_status' is not a valid ownership_status"
    end

    context 'income' do
      let(:customer) { build(:customer, :with_risk_profile, income: -1) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      'Validation failed: Income must be greater than or equal to 0'
    end

    context 'marital status' do
      let(:customer) { build(:customer, :with_risk_profile, marital_status: :separated) }
      it_behaves_like 'an exception', ArgumentError, "'separated' is not a valid marital_status"
    end

    context 'risk questions' do
      let(:risk_profile) { build(:risk_profile, risk_questions: %i[no yes no]) }
      let(:customer) { build(:customer, :with_risk_profile, risk_profile:) }
      it 'does NOT raise an exception' do
        expect { subject }.not_to raise_error
      end
      it_behaves_like 'a valid risk profile'
    end

    context 'vehicle' do
      let(:vehicle) { build(:vehicle, year: Time.current.year + 1) }
      let(:customer) { build(:customer, :with_risk_profile, vehicle:) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      "Validation failed: Year must be less than or equal to #{Time.current.year}"
    end
  end

  context 'without attributes' do
    context 'age' do
      let(:customer) { build(:customer, :with_risk_profile, age: nil) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      "Validation failed: Age can't be blank, Age is not a number"
    end

    context 'dependents' do
      let(:customer) { build(:customer, :with_risk_profile, dependents: nil) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      "Validation failed: Dependents can't be blank, Dependents is not a number"
    end

    context 'house' do
      let(:customer) { build(:customer, :with_risk_profile) }
      it 'does NOT raise an exception' do
        expect { subject }.not_to raise_error
      end
      it_behaves_like 'a valid risk profile'
    end

    context 'income' do
      let(:customer) { build(:customer, :with_risk_profile, income: nil) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid,
                      "Validation failed: Income can't be blank, Income is not a number"
    end

    context 'marital status' do
      let(:customer) { build(:customer, :with_risk_profile, marital_status: nil) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid, "Validation failed: Marital status can't be blank"
    end

    context 'risk questions' do
      let(:risk_profile) { build(:risk_profile, risk_questions: nil) }
      let(:customer) { build(:customer, :with_risk_profile, risk_profile:) }
      it_behaves_like 'an exception', ActiveRecord::RecordInvalid, "Validation failed: Risk questions can't be blank"
    end

    context 'vehicle' do
      let(:customer) { build(:customer, :with_risk_profile) }
      it 'does NOT raise an exception' do
        expect { subject }.not_to raise_error
      end
      it_behaves_like 'a valid risk profile'
    end
  end
end
