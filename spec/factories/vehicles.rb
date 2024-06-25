# == Schema Information
#
# Table name: vehicles
#
#  id          :bigint           not null, primary key
#  year        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#
# Indexes
#
#  index_vehicles_on_customer_id  (customer_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
FactoryBot.define do
  factory :vehicle do
    customer
    year { Faker::Vehicle.year }

    # scenario where attributes do NOT trigger any risk score change
    trait :static do
      year { Time.current.year - 6 }
    end
  end
end
