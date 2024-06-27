# frozen_string_literal: true

module V1
  class RiskProfilesController < ApplicationController
    # POST /v1/risk_profiles/calculate_for_customer
    def calculate_for_customer
      @risk_profile = CalculateRiskProfileForCustomer.call!(risk_profile_for_customer_params)

      render json: @risk_profile
    end

    private

    def risk_profile_for_customer_params
      params.permit(:age, :dependents, :income, :marital_status,
                    risk_questions: [], house: :ownership_status, vehicle: :year)
    end
  end
end
