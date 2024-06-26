# frozen_string_literal: true

# == Schema Information
#
# Table name: risk_profiles
#
#  id               :bigint           not null, primary key
#  auto             :integer          not null
#  auto_score       :integer          not null
#  base_score       :integer          not null
#  disability       :integer          not null
#  disability_score :integer          not null
#  home             :integer          not null
#  home_score       :integer          not null
#  life             :integer          not null
#  life_score       :integer          not null
#  risk_questions   :boolean          not null, is an Array
#  riskable_type    :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  riskable_id      :bigint           not null
#
# Indexes
#
#  index_risk_profiles_on_riskable  (riskable_type,riskable_id) UNIQUE
#
class RiskProfile < ApplicationRecord
  SCORE_TIERS = %i[inelegivel economico padrao avancado].freeze

  belongs_to :riskable, inverse_of: :risk_profile, polymorphic: true, required: true

  validates :riskable_id, uniqueness: { scope: :riskable_type }
  validates :auto, :disability, :home, :life, :risk_questions, presence: true, on: %i[create update]
  validates :auto_score, :base_score, :disability_score, :home_score, :life_score, presence: true,
                                                                                   on: %i[create update]
  validates :risk_questions, presence: true, on: :before_calculation

  enum auto: SCORE_TIERS, _prefix: true
  enum disability: SCORE_TIERS, _prefix: true
  enum home: SCORE_TIERS, _prefix: true
  enum life: SCORE_TIERS, _prefix: true
end
