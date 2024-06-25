# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id             :bigint           not null, primary key
#  age            :integer          not null
#  dependents     :integer          not null
#  income         :integer          not null
#  marital_status :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :customer do
    age { Time.current.year - Faker::Date.birthday.year }
    dependents { [0, 1, 2].sample }
    income { Faker::Number.between(from: 0, to: 250_000) }
    marital_status { Customer.marital_statuses.keys.sample }

    trait :with_house do
      house
    end

    trait :with_vehicle do
      vehicle
    end

    trait :with_risk_profile do
      risk_profile
    end

    # scenario where attributes do NOT trigger any risk score change
    trait :static do
      age { 45 }
      dependents { 0 }
      income { 1 }
      marital_status { :single }
      house
      association :vehicle, :static
      association :risk_profile, :static
    end
  end
end
