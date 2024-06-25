# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.references :customer, null: false, foreign_key: true, index: { unique: true }
      t.integer :year, null: false

      t.timestamps
    end
  end
end
