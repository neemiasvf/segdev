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
require 'rails_helper'

RSpec.describe RiskProfile, type: :model do
  context 'when riskable is a Customer' do
    subject { build(:risk_profile, :calculated) }

    it { should have_db_column(:id).of_type(:integer).with_options(null: false, primary: true) }
    it { should have_db_column(:auto).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:auto_score).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:base_score).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:disability).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:disability_score).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:home).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:home_score).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:life).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:life_score).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:risk_questions).of_type(:boolean).with_options(null: false, array: true) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:riskable_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:riskable_type).of_type(:string).with_options(null: false) }
    it { should have_db_index(%i[riskable_type riskable_id]).unique(true) }

    it { should belong_to(:riskable).inverse_of(:risk_profile).required(true) }

    it { should validate_presence_of :auto }
    it { should validate_presence_of :auto_score }
    it { should validate_presence_of :base_score }
    it { should validate_presence_of :disability }
    it { should validate_presence_of :disability_score }
    it { should validate_presence_of :home }
    it { should validate_presence_of :home_score }
    it { should validate_presence_of :life }
    it { should validate_presence_of :life_score }
    it { should validate_presence_of :risk_questions }
    it { should validate_presence_of(:risk_questions).on(:before_calculation) }
    it { should validate_uniqueness_of(:riskable_id).scoped_to(:riskable_type) }

    it { should define_enum_for(:auto).with_values(RiskProfile::SCORE_TIERS).with_prefix(true) }
    it { should define_enum_for(:disability).with_values(RiskProfile::SCORE_TIERS).with_prefix(true) }
    it { should define_enum_for(:home).with_values(RiskProfile::SCORE_TIERS).with_prefix(true) }
    it { should define_enum_for(:life).with_values(RiskProfile::SCORE_TIERS).with_prefix(true) }
  end
end
