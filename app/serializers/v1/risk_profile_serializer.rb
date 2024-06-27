# frozen_string_literal: true

module V1
  class RiskProfileSerializer < ::BaseSerializer
    attributes %i[auto disability home life]
  end
end
