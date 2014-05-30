# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140530202732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "parties", force: true do |t|
    t.string   "name"
    t.boolean  "private"
    t.string   "description"
    t.datetime "scheduled_for"
    t.integer  "organizer_id"
    t.integer  "team_id"
    t.integer  "sport_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified"
  end

  add_index "parties", ["organizer_id"], name: "index_parties_on_organizer_id", using: :btree
  add_index "parties", ["sport_id"], name: "index_parties_on_sport_id", using: :btree
  add_index "parties", ["team_id"], name: "index_parties_on_team_id", using: :btree

  create_table "party_invitations", force: true do |t|
    t.integer "user_id"
    t.integer "party_id"
    t.string  "unregistered_invitee_email"
    t.integer "inviter_id"
    t.string  "uuid"
    t.boolean "claimed",                    default: false
  end

  add_index "party_invitations", ["party_id"], name: "index_party_invitations_on_party_id", using: :btree
  add_index "party_invitations", ["user_id"], name: "index_party_invitations_on_user_id", using: :btree

  create_table "party_reservations", force: true do |t|
    t.integer "user_id"
    t.integer "party_id"
    t.string  "unregistered_rsvp_email"
  end

  add_index "party_reservations", ["party_id"], name: "index_party_reservations_on_party_id", using: :btree
  add_index "party_reservations", ["user_id"], name: "index_party_reservations_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sport_subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "sport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sports", force: true do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_host_endorsements", force: true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_host_endorsements", ["team_id"], name: "index_team_host_endorsements_on_team_id", using: :btree
  add_index "team_host_endorsements", ["user_id"], name: "index_team_host_endorsements_on_user_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "image_url"
    t.integer  "sport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "admin_id"
  end

  add_index "teams", ["admin_id"], name: "index_teams_on_admin_id", using: :btree

  create_table "user_team_subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_team_subscriptions", ["team_id"], name: "index_user_team_subscriptions_on_team_id", using: :btree
  add_index "user_team_subscriptions", ["user_id"], name: "index_user_team_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "venue_sport_subscriptions", force: true do |t|
    t.integer  "venue_id"
    t.integer  "sport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venue_sport_subscriptions", ["sport_id"], name: "index_venue_sport_subscriptions_on_sport_id", using: :btree
  add_index "venue_sport_subscriptions", ["venue_id"], name: "index_venue_sport_subscriptions_on_venue_id", using: :btree

  create_table "venue_team_subscriptions", force: true do |t|
    t.integer  "venue_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venue_team_subscriptions", ["team_id"], name: "index_venue_team_subscriptions_on_team_id", using: :btree
  add_index "venue_team_subscriptions", ["venue_id"], name: "index_venue_team_subscriptions_on_venue_id", using: :btree

  create_table "venues", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "image_url"
    t.integer "user_id"
  end

  add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree

end
