# frozen_string_literal: true

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
class Vehicle < ApplicationRecord
  belongs_to :customer, inverse_of: :vehicle, required: true

  validates :customer, uniqueness: true
  validates :year, presence: true
  validates :year, numericality: { less_than_or_equal_to: Time.current.year }
end
