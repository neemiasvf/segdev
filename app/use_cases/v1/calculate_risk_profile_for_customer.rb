# frozen_string_literal: true

module V1
  class CalculateRiskProfileForCustomer < ::BaseUseCase
    attr_reader :risk_profile, :customer

    def initialize(params)
      super
      @customer = Customer.new(@params.except(:house, :vehicle, :risk_questions))
      @customer.house = House.new(@params[:house]) if @params[:house]
      @customer.vehicle = Vehicle.new(@params[:vehicle]) if @params[:vehicle]
      @risk_profile = RiskProfile.new(riskable: @customer, risk_questions: @params[:risk_questions])
    end

    def call!
      validate_params!
      calculate_risk_profile!
      @risk_profile
    end

    private

    def validate_params!
      raise ActiveRecord::RecordInvalid, @customer.house if @customer.house&.invalid?
      raise ActiveRecord::RecordInvalid, @customer.vehicle if @customer.vehicle&.invalid?
      raise ActiveRecord::RecordInvalid, @customer if @customer.invalid?
      raise ActiveRecord::RecordInvalid, @risk_profile if @risk_profile.invalid?(:before_calculation)
    end

    def calculate_risk_profile!
      @risk_profile = CalculateRiskProfile.call!(@risk_profile)
    end
  end
end
