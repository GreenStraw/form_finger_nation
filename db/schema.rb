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

ActiveRecord::Schema.define(version: 20170928052227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "addressable_id"
    t.string "addressable_type", limit: 255
    t.string "street1", limit: 255
    t.string "street2", limit: 255
    t.string "city", limit: 255
    t.string "state", limit: 255
    t.string "zip", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "ph_number", limit: 255
    t.index ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type"
  end

  create_table "authorizations", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.integer "user_id"
    t.string "token", limit: 255
    t.string "secret", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "username", limit: 255
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type", limit: 255
    t.integer "commenter_id"
    t.string "commenter_type", limit: 255
    t.string "title", limit: 255
    t.text "body"
    t.string "subject", limit: 255
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["commenter_id", "commenter_type"], name: "index_comments_on_commenter_id_and_commenter_type"
  end

  create_table "endorsement_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.string "status", limit: 255, default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "endorsements", id: :serial, force: :cascade do |t|
    t.integer "endorsable_id"
    t.string "endorsable_type", limit: 255
    t.integer "endorser_id"
    t.string "endorser_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["endorsable_id", "endorsable_type"], name: "index_endorsements_on_endorsable_id_and_endorsable_type"
    t.index ["endorser_id", "endorser_type"], name: "index_endorsements_on_endorser_id_and_endorser_type"
  end

  create_table "favorites", id: :serial, force: :cascade do |t|
    t.integer "favoritable_id"
    t.string "favoritable_type", limit: 255
    t.integer "favoriter_id"
    t.string "favoriter_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["favoritable_id", "favoritable_type"], name: "index_favorites_on_favoritable_id_and_favoritable_type"
    t.index ["favoriter_id", "favoriter_type"], name: "index_favorites_on_favoriter_id_and_favoriter_type"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "packages", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.string "image_url", limit: 255
    t.decimal "price"
    t.boolean "active"
    t.boolean "is_public", default: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "for_everyone", default: true
  end

  create_table "parties", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "is_private", default: false
    t.boolean "verified", default: false
    t.datetime "scheduled_for"
    t.integer "organizer_id"
    t.integer "team_id"
    t.integer "sport_id"
    t.integer "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.string "friendly_url", limit: 255
    t.string "image_url", limit: 255
    t.integer "max_rsvp"
    t.string "type", limit: 255
    t.string "business_name", limit: 255
    t.string "tags", limit: 255
    t.string "invite_type", limit: 255
    t.text "description"
    t.string "sponsor", limit: 255
    t.string "sponser_image", limit: 255
    t.string "banner", limit: 255
    t.string "who_created_location", limit: 255
    t.boolean "is_cancelled", default: false
    t.string "cancel_description", limit: 255
    t.index ["organizer_id"], name: "index_parties_on_organizer_id"
    t.index ["sport_id"], name: "index_parties_on_sport_id"
    t.index ["team_id"], name: "index_parties_on_team_id"
  end

  create_table "party_invitations", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.string "uuid", limit: 255
    t.string "status", limit: 255, default: "pending"
    t.integer "inviter_id"
    t.integer "user_id"
    t.integer "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["inviter_id"], name: "index_party_invitations_on_inviter_id"
    t.index ["party_id"], name: "index_party_invitations_on_party_id"
    t.index ["user_id"], name: "index_party_invitations_on_user_id"
  end

  create_table "party_packages", id: :serial, force: :cascade do |t|
    t.integer "party_id"
    t.integer "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "party_reservations", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.integer "user_id"
    t.integer "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_party_reservations_on_email"
    t.index ["party_id"], name: "index_party_reservations_on_party_id"
    t.index ["user_id"], name: "index_party_reservations_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "resource_id"
    t.string "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sports", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "image_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "image_url", limit: 255
    t.text "information"
    t.boolean "college", default: false
    t.integer "sport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "twitter_widget_id", limit: 255
    t.string "twitter_name", limit: 255
    t.string "website", limit: 255
    t.string "banner", limit: 255
    t.string "page_name", limit: 255
    t.string "team_icon", limit: 255
    t.index ["name"], name: "index_teams_on_name"
    t.index ["sport_id"], name: "index_teams_on_sport_id"
  end

  create_table "tenants", id: :serial, force: :cascade do |t|
    t.integer "tenant_id"
    t.string "name", limit: 255
    t.string "api_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_tenants_on_name"
    t.index ["tenant_id"], name: "index_tenants_on_tenant_id"
  end

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.integer "tenant_id", null: false
    t.integer "user_id", null: false
    t.index ["tenant_id", "user_id"], name: "index_tenants_users_on_tenant_id_and_user_id"
  end

  create_table "user_purchased_packages", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "package_id"
    t.integer "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["package_id"], name: "index_user_purchased_packages_on_package_id"
    t.index ["party_id"], name: "index_user_purchased_packages_on_party_id"
    t.index ["user_id"], name: "index_user_purchased_packages_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token", limit: 255
    t.datetime "locked_at"
    t.boolean "skip_confirm_change_password", default: false
    t.integer "tenant_id"
    t.string "authentication_token", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "role", limit: 255
    t.string "username", limit: 255
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.string "customer_id", limit: 255
    t.string "facebook_access_token", limit: 255
    t.string "image_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.string "requested_role", limit: 255, default: "Sports Fan"
    t.string "website", limit: 255
    t.string "about", limit: 255
    t.string "gender", limit: 255
    t.integer "favorite_team_id"
    t.string "location", limit: 255
    t.string "banner", limit: 255
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "venues", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.string "image_url", limit: 255
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "phone", limit: 255
    t.string "email", limit: 255
    t.string "hours_sunday", limit: 255
    t.string "hours_monday", limit: 255
    t.string "hours_tuesday", limit: 255
    t.string "hours_wednesday", limit: 255
    t.string "hours_thursday", limit: 255
    t.string "hours_friday", limit: 255
    t.string "hours_saturday", limit: 255
    t.string "website", limit: 255
    t.string "created_by", limit: 10
    t.index ["user_id"], name: "index_venues_on_user_id"
  end

  create_table "vouchers", id: :serial, force: :cascade do |t|
    t.string "transaction_display_id", limit: 255
    t.string "transaction_id", limit: 255
    t.datetime "redeemed_at"
    t.integer "user_id"
    t.integer "package_id"
    t.integer "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
