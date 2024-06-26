# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_626_181_039) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'customers', force: :cascade do |t|
    t.integer 'age', null: false
    t.integer 'dependents', null: false
    t.integer 'income', null: false
    t.integer 'marital_status', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'houses', force: :cascade do |t|
    t.bigint 'customer_id', null: false
    t.integer 'ownership_status', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['customer_id'], name: 'index_houses_on_customer_id', unique: true
  end

  create_table 'risk_profiles', force: :cascade do |t|
    t.string 'riskable_type', null: false
    t.bigint 'riskable_id', null: false
    t.integer 'auto', null: false
    t.integer 'auto_score', null: false
    t.integer 'base_score', null: false
    t.integer 'disability', null: false
    t.integer 'disability_score', null: false
    t.integer 'home', null: false
    t.integer 'home_score', null: false
    t.integer 'life', null: false
    t.integer 'life_score', null: false
    t.boolean 'risk_questions', null: false, array: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[riskable_type riskable_id], name: 'index_risk_profiles_on_riskable', unique: true
  end

  create_table 'vehicles', force: :cascade do |t|
    t.bigint 'customer_id', null: false
    t.integer 'year', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['customer_id'], name: 'index_vehicles_on_customer_id', unique: true
  end

  add_foreign_key 'houses', 'customers'
  add_foreign_key 'vehicles', 'customers'
end
