# frozen_string_literal: true

module V1
  class CalculateRiskProfile < ::BaseService
    attr_reader :risk_profile, :riskable

    def initialize(risk_profile) # rubocop:disable Lint/MissingSuper
      @risk_profile = risk_profile
      @riskable = risk_profile.riskable
    end

    def call!
      calculate_for_customer if riskable.is_a?(Customer)

      @risk_profile
    end

    private

    def calculate_for_customer
      calculate_base_score
      calculate_age
      calculate_dependents
      calculate_income
      calculate_marital_status
      calculate_house
      calculate_vehicle
      assign_scores_for_customer
    end

    def calculate_base_score
      @risk_profile.base_score = @risk_profile.risk_questions.count(true)
      @risk_profile.auto_score = @risk_profile.base_score
      @risk_profile.disability_score = @risk_profile.base_score
      @risk_profile.home_score = @risk_profile.base_score
      @risk_profile.life_score = @risk_profile.base_score
    end

    def calculate_age # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      if @riskable.age < 30
        @risk_profile.auto_score -= 2
        @risk_profile.disability_score -= 2
        @risk_profile.home_score -= 2
        @risk_profile.life_score -= 2
      elsif @riskable.age in 30..40
        @risk_profile.auto_score -= 1
        @risk_profile.disability_score -= 1
        @risk_profile.home_score -= 1
        @risk_profile.life_score -= 1
      elsif @riskable.age > 60
        @risk_profile.life = :inelegivel
        @risk_profile.disability = :inelegivel
      end
    end

    def calculate_dependents
      return unless @riskable.dependents.positive?

      @risk_profile.disability_score += 1
      @risk_profile.life_score += 1
    end

    def calculate_income
      if @riskable.income.zero?
        @risk_profile.disability = :inelegivel
      elsif @riskable.income > 200_000
        @risk_profile.auto_score -= 1
        @risk_profile.disability_score -= 1
        @risk_profile.home_score -= 1
        @risk_profile.life_score -= 1
      end
    end

    def calculate_marital_status
      return unless @riskable.married?

      @risk_profile.disability_score -= 1
      @risk_profile.life_score += 1
    end

    def calculate_house
      if @riskable.house.blank?
        @risk_profile.home = :inelegivel
      elsif @riskable.house.rented?
        @risk_profile.disability_score += 1
        @risk_profile.home_score += 1
      end
    end

    def calculate_vehicle
      if @riskable.vehicle.blank?
        @risk_profile.auto = :inelegivel
      elsif @riskable.vehicle.year >= Time.current.year - 5
        @risk_profile.auto_score += 1
      end
    end

    def assign_scores_for_customer
      @risk_profile.auto ||= score_tier_for_customer(@risk_profile.auto_score)
      @risk_profile.disability ||= score_tier_for_customer(@risk_profile.disability_score)
      @risk_profile.home ||= score_tier_for_customer(@risk_profile.home_score)
      @risk_profile.life ||= score_tier_for_customer(@risk_profile.life_score)
    end

    def score_tier_for_customer(score)
      case score
      when ->(score) { score <= 0 }
        :economico
      when 1..2
        :padrao
      when ->(score) { score >= 3 }
        :avancado
      end
    end
  end
end
