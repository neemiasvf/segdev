# frozen_string_literal: true

class CreateHouses < ActiveRecord::Migration[7.1]
  def change
    create_table :houses do |t|
      t.references :customer, null: false, foreign_key: true, index: { unique: true }
      t.integer :ownership_status, null: false

      t.timestamps
    end
  end
end
