# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RiskProfilesController, type: :routing do
  it {
    should route(:post, '/v1/risk_profiles/calculate_for_customer').to(controller: 'v1/risk_profiles',
                                                                       action: :calculate_for_customer, format: :json)
  }
end
