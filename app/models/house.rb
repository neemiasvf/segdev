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
class House < ApplicationRecord
  belongs_to :customer, inverse_of: :house, required: true

  validates :customer, uniqueness: true
  validates :ownership_status, presence: true

  enum ownership_status: %i[owned rented]
end
