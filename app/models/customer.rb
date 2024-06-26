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
class Customer < ApplicationRecord
  has_one :house, dependent: :destroy, inverse_of: :customer
  has_one :risk_profile, dependent: :destroy, as: :riskable, inverse_of: :riskable
  has_one :vehicle, dependent: :destroy, inverse_of: :customer

  validates :age, :dependents, :income, :marital_status, presence: true
  validates :age, :dependents, :income, numericality: { greater_than_or_equal_to: 0 }
  validates_associated :house, :vehicle

  enum marital_status: %i[single married]
end
