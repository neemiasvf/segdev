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
require 'rails_helper'

RSpec.describe House, type: :model do
  subject { build(:house) }

  it { should have_db_column(:id).of_type(:integer).with_options(null: false, primary: true) }
  it { should have_db_column(:ownership_status).of_type(:integer).with_options(null: false) }
  it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { should have_db_column(:customer_id).of_type(:integer).with_options(null: false) }
  it { should have_db_index(:customer_id).unique(true) }

  it { should belong_to(:customer).inverse_of(:house).required(true) }

  it { should validate_uniqueness_of :customer }
  it { should validate_presence_of :ownership_status }

  it { should define_enum_for(:ownership_status).with_values(%i[owned rented]) }
end
