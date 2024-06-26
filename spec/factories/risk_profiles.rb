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
FactoryBot.define do
  factory :risk_profile do
    for_customer

    trait :for_customer do
      association :riskable, factory: :customer
    end

    auto_score { base_score }
    base_score { risk_questions&.count(true) }
    disability_score { base_score }
    home_score { base_score }
    life_score { base_score }
    risk_questions { Array.new(3) { [0, 1].sample } }

    # scenario where attributes do NOT trigger any risk score change
    trait :static do
      risk_questions { [false, true, false] }
    end

    # scenario where risk scores were already calculated, supposedly
    trait :calculated do
      auto { :padrao }
      disability { :padrao }
      home { :padrao }
      life { :padrao }
    end

    trait :economico do
      risk_questions { [false, false, false] }
    end

    trait :padrao do
      static
    end

    trait :avancado do
      risk_questions { [true, true, true] }
    end
  end
end
