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
require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject { build(:vehicle) }

  it { should have_db_column(:id).of_type(:integer).with_options(null: false, primary: true) }
  it { should have_db_column(:year).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { should have_db_column(:customer_id).of_type(:integer).with_options(null: false) }
  it { should have_db_index(:customer_id).unique(true) }

  it { should belong_to(:customer).inverse_of(:vehicle).required(true) }

  it { should validate_uniqueness_of :customer }
  it { should validate_presence_of :year }
  it { should validate_numericality_of(:year).is_less_than_or_equal_to(Time.current.year) }
end
