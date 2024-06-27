# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::CalculateRiskProfile, type: :service do
  subject { described_class.call!(risk_profile) }

  shared_examples 'decreases all risk scores by 1 point' do
    it 'should decrease auto risk score by 1 point' do
      expect { subject }.to change(risk_profile, :auto_score).by(-1)
                                                             .and change(risk_profile, :auto_score).from(1).to(0)
    end

    it 'should decrease disability risk score by 1 point' do
      expect { subject }.to change(risk_profile, :disability_score).by(-1)
                                                                   .and change(risk_profile,
                                                                               :disability_score).from(1).to(0)
    end

    it 'should decrease home risk score by 1 point' do
      expect { subject }.to change(risk_profile, :home_score).by(-1)
                                                             .and change(risk_profile, :home_score).from(1).to(0)
    end

    it 'should decrease life risk score by 1 point' do
      expect { subject }.to change(risk_profile, :life_score).by(-1)
                                                             .and change(risk_profile,
                                                                         :life_score).from(1).to(0)
    end
  end

  shared_examples 'decreases all risk scores by 2 points' do
    it 'should decrease auto risk score by 2 points' do
      expect { subject }.to change(risk_profile, :auto_score).by(-2)
                                                             .and change(risk_profile, :auto_score).from(1).to(-1)
    end

    it 'should decrease disability risk score by 2 points' do
      expect { subject }.to change(risk_profile, :disability_score).by(-2)
                                                                   .and change(risk_profile,
                                                                               :disability_score).from(1).to(-1)
    end

    it 'should decrease home risk score by 2 points' do
      expect { subject }.to change(risk_profile, :home_score).by(-2)
                                                             .and change(risk_profile, :home_score).from(1).to(-1)
    end

    it 'should decrease life risk score by 2 points' do
      expect { subject }.to change(risk_profile, :life_score).by(-2)
                                                             .and change(risk_profile,
                                                                         :life_score).from(1).to(-1)
    end
  end

  shared_examples 'should have expected tier for all risk scores' do
    it 'should expected tier for auto' do
      expect { subject }.to change(risk_profile, :auto).from(nil).to(expected_tier)
    end
    it 'should expected tier for disability' do
      expect { subject }.to change(risk_profile, :disability).from(nil).to(expected_tier)
    end
    it 'should expected tier for home' do
      expect { subject }.to change(risk_profile, :home).from(nil).to(expected_tier)
    end
    it 'should expected tier for life' do
      expect { subject }.to change(risk_profile, :life).from(nil).to(expected_tier)
    end
  end

  context 'when riskable is a Customer' do
    let(:risk_profile) { build(:risk_profile, :for_customer) }

    context 'when customer does NOT have income' do
      let(:customer) { build(:customer, income: 0) }
      let(:risk_profile) { build(:risk_profile, :for_customer, riskable: customer) }

      it "should be 'inelegivel' for disability" do
        expect { subject }.to change(risk_profile, :disability).from(nil).to('inelegivel')
      end
    end

    context 'when customer does NOT have house' do
      it "should be 'inelegivel' for home" do
        expect { subject }.to change(risk_profile, :home).from(nil).to('inelegivel')
      end
    end

    context 'when customer does NOT have vehicle' do
      it "should be 'inelegivel' for auto" do
        expect { subject }.to change(risk_profile, :auto).from(nil).to('inelegivel')
      end
    end

    context 'when customer is less than 30 years old' do
      let(:customer) { build(:customer, :static, age: Faker::Number.between(from: 0, to: 29)) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it_behaves_like 'decreases all risk scores by 2 points'
    end

    context 'when customer is between 30 and 40 years old' do
      let(:customer) { build(:customer, :static, age: Faker::Number.between(from: 30, to: 40)) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it_behaves_like 'decreases all risk scores by 1 point'
    end

    context 'when customer is more than 60 years old' do
      let(:customer) { build(:customer, age: Faker::Number.between(from: 61, to: 120)) }
      let(:risk_profile) { build(:risk_profile, :for_customer, riskable: customer) }

      it "should be 'inelegivel' for disability" do
        expect { subject }.to change(risk_profile, :disability).from(nil).to('inelegivel')
      end

      it "should be 'inelegivel' for life" do
        expect { subject }.to change(risk_profile, :life).from(nil).to('inelegivel')
      end
    end

    context "when customer's income is greater than 200_000" do
      let(:customer) { build(:customer, :static, income: Faker::Number.between(from: 200_001, to: 1_000_000)) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it_behaves_like 'decreases all risk scores by 1 point'
    end

    context "when customer's house is rented" do
      let(:rented_house) { build(:house, :rented) }
      let(:customer) { build(:customer, :static, house: rented_house) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it 'should increase disability risk score by 1 point' do
        expect { subject }.to change(risk_profile, :disability_score).by(1)
                                                                     .and change(risk_profile,
                                                                                 :disability_score).from(1).to(2)
      end

      it 'should increase home risk score by 1 point' do
        expect { subject }.to change(risk_profile, :home_score).by(1)
                                                               .and change(risk_profile,
                                                                           :home_score).from(1).to(2)
      end
    end

    context 'when customer has dependents' do
      let(:customer) { build(:customer, :static, dependents: Faker::Number.between(from: 1, to: 10)) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it 'should increase disability risk score by 1 point' do
        expect { subject }.to change(risk_profile, :disability_score).by(1)
                                                                     .and change(risk_profile,
                                                                                 :disability_score).from(1).to(2)
      end

      it 'should increase life risk score by 1 point' do
        expect { subject }.to change(risk_profile, :life_score).by(1)
                                                               .and change(risk_profile,
                                                                           :life_score).from(1).to(2)
      end
    end

    context 'when customer is married' do
      let(:customer) { build(:customer, :static, marital_status: :married) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it 'should decrease disability risk score by 1 point' do
        expect { subject }.to change(risk_profile, :disability_score).by(-1)
                                                                     .and change(risk_profile,
                                                                                 :disability_score).from(1).to(0)
      end

      it 'should increase life risk score by 1 point' do
        expect { subject }.to change(risk_profile, :life_score).by(1)
                                                               .and change(risk_profile,
                                                                           :life_score).from(1).to(2)
      end
    end

    context "when customer's car was manufactured within the last 5 years" do
      let(:new_vehicle) { build(:vehicle, year: Time.current.year) }
      let(:customer) { build(:customer, :static, vehicle: new_vehicle) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, riskable: customer) }

      it 'should increase auto risk score by 1 point' do
        expect { subject }.to change(risk_profile, :auto_score).by(1)
                                                               .and change(risk_profile,
                                                                           :auto_score).from(1).to(2)
      end
    end

    context 'when risk score is less than or equal to 0' do
      let(:customer) { build(:customer, :static) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, :economico, riskable: customer) }
      let(:expected_tier) { 'economico' }

      it_behaves_like 'should have expected tier for all risk scores'
    end

    context 'when risk score is between 1 and 2' do
      let(:customer) { build(:customer, :static) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, :padrao, riskable: customer) }
      let(:expected_tier) { 'padrao' }

      context 'when risk score is exactly 1' do
        it_behaves_like 'should have expected tier for all risk scores'
      end

      context 'when risk score is exactly 2' do
        let(:risk_questions) { [true, true, false] }
        let(:risk_profile) do
          build(:risk_profile, :for_customer, :static, :padrao, riskable: customer, risk_questions:)
        end

        it_behaves_like 'should have expected tier for all risk scores'
      end
    end

    context 'when risk score is greater than or equal to 3' do
      let(:customer) { build(:customer, :static) }
      let(:risk_profile) { build(:risk_profile, :for_customer, :static, :avancado, riskable: customer) }
      let(:expected_tier) { 'avancado' }

      it_behaves_like 'should have expected tier for all risk scores'
    end
  end
end
