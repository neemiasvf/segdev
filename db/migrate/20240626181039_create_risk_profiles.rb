# frozen_string_literal: true

class CreateRiskProfiles < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :risk_profiles do |t|
      t.references :riskable, polymorphic: true, null: false, index: { unique: true }
      t.integer :auto, null: false
      t.integer :auto_score, null: false
      t.integer :base_score, null: false
      t.integer :disability, null: false
      t.integer :disability_score, null: false
      t.integer :home, null: false
      t.integer :home_score, null: false
      t.integer :life, null: false
      t.integer :life_score, null: false
      t.boolean :risk_questions, null: false, array: true

      t.timestamps
    end
  end
end
