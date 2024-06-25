# frozen_string_literal: true

# == Schema Information
#
# Table name: houses
#
#  id               :bigint           not null, primary key
#  ownership_status :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  customer_id      :bigint           not null
#
# Indexes
#
#  index_houses_on_customer_id  (customer_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
FactoryBot.define do
  factory :house do
    customer
    ownership_status { :owned }

    trait :rented do
      ownership_status { :rented }
    end

    factory :rented_house, traits: %i[rented]
  end
end
