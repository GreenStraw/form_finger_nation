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

ActiveRecord::Schema.define(version: 20140611233153) do

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
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "commenter_id"
    t.string   "commenter_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["commenter_id", "commenter_type"], name: "index_comments_on_commenter_id_and_commenter_type", using: :btree

  create_table "endorsements", force: true do |t|
    t.integer "endorsable_id"
    t.string  "endorsable_type"
    t.integer "endorser_id"
    t.string  "endorser_type"
  end

  add_index "endorsements", ["endorsable_id", "endorsable_type"], name: "index_endorsements_on_endorsable_id_and_endorsable_type", using: :btree
  add_index "endorsements", ["endorser_id", "endorser_type"], name: "index_endorsements_on_endorser_id_and_endorser_type", using: :btree

  create_table "favorites", force: true do |t|
    t.integer "favoritable_id"
    t.string  "favoritable_type"
    t.integer "favoriter_id"
    t.string  "favoriter_type"
  end

  add_index "favorites", ["favoritable_id", "favoritable_type"], name: "index_favorites_on_favoritable_id_and_favoritable_type", using: :btree
  add_index "favorites", ["favoriter_id", "favoriter_type"], name: "index_favorites_on_favoriter_id_and_favoriter_type", using: :btree

  create_table "packages", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image_url"
    t.decimal  "price"
    t.boolean  "active"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "venue_id"
  end

  create_table "parties", force: true do |t|
    t.string   "name"
    t.boolean  "private",       default: false
    t.boolean  "verified",      default: false
    t.string   "description"
    t.datetime "scheduled_for"
    t.integer  "organizer_id"
    t.integer  "team_id"
    t.integer  "sport_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parties", ["organizer_id"], name: "index_parties_on_organizer_id", using: :btree
  add_index "parties", ["sport_id"], name: "index_parties_on_sport_id", using: :btree
  add_index "parties", ["team_id"], name: "index_parties_on_team_id", using: :btree

  create_table "party_invitations", force: true do |t|
    t.string  "unregistered_invitee_email"
    t.string  "uuid"
    t.integer "inviter_id"
    t.boolean "claimed",                    default: false
    t.integer "user_id"
    t.integer "party_id"
  end

  add_index "party_invitations", ["inviter_id"], name: "index_party_invitations_on_inviter_id", using: :btree
  add_index "party_invitations", ["party_id"], name: "index_party_invitations_on_party_id", using: :btree
  add_index "party_invitations", ["user_id"], name: "index_party_invitations_on_user_id", using: :btree

  create_table "party_reservations", force: true do |t|
    t.string  "unregistered_rsvp_email"
    t.integer "user_id"
    t.integer "party_id"
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

  create_table "sports", force: true do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "image_url"
    t.integer  "sport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "information"
  end

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
    t.string   "last_name"
    t.string   "first_name"
    t.string   "username"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "venues", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "image_url"
    t.integer "user_id"
    t.string  "venue_type",   default: "Venue"
    t.integer "franchise_id"
  end

  add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree

end
