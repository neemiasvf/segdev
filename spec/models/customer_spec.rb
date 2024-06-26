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
require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_db_column(:id).of_type(:integer).with_options(null: false, primary: true) }
  it { should have_db_column(:age).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:dependents).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:income).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:marital_status).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

  it { should have_one(:house).dependent(:destroy).inverse_of(:customer) }
  it { should have_one(:risk_profile).dependent(:destroy).inverse_of(:riskable) }
  it { should have_one(:vehicle).dependent(:destroy).inverse_of(:customer) }

  it { should validate_presence_of :age }
  it { should validate_presence_of :dependents }
  it { should validate_presence_of :income }
  it { should validate_presence_of :marital_status }

  it { should validate_numericality_of(:age).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:dependents).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:income).is_greater_than_or_equal_to(0) }

  it { should define_enum_for(:marital_status).with_values(%i[single married]) }
end
