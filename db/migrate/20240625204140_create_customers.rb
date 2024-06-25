# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.integer :age, null: false
      t.integer :dependents, null: false
      t.integer :income, null: false
      t.integer :marital_status, null: false

      t.timestamps
    end
  end
end
