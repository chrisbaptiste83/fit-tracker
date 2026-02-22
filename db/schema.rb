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

ActiveRecord::Schema[8.0].define(version: 2026_02_05_071647) do
  create_table "ai_conversations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "context"
    t.json "messages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ai_conversations_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.string "muscle_group"
    t.string "equipment_needed"
    t.string "difficulty"
    t.decimal "calories_per_minute"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.decimal "serving_size"
    t.string "serving_unit"
    t.integer "calories"
    t.decimal "protein"
    t.decimal "carbs"
    t.decimal "fat"
    t.decimal "fiber"
    t.string "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "goal_type"
    t.decimal "target_value"
    t.decimal "current_value"
    t.string "unit"
    t.date "start_date"
    t.date "target_date"
    t.datetime "completed_at"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "meal_foods", force: :cascade do |t|
    t.integer "meal_id", null: false
    t.integer "food_id", null: false
    t.decimal "servings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_meal_foods_on_food_id"
    t.index ["meal_id"], name: "index_meal_foods_on_meal_id"
  end

  create_table "meal_plan_days", force: :cascade do |t|
    t.integer "meal_plan_id", null: false
    t.integer "day_of_week"
    t.integer "breakfast_recipe_id"
    t.integer "lunch_recipe_id"
    t.integer "dinner_recipe_id"
    t.text "snacks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["breakfast_recipe_id"], name: "index_meal_plan_days_on_breakfast_recipe_id"
    t.index ["dinner_recipe_id"], name: "index_meal_plan_days_on_dinner_recipe_id"
    t.index ["lunch_recipe_id"], name: "index_meal_plan_days_on_lunch_recipe_id"
    t.index ["meal_plan_id"], name: "index_meal_plan_days_on_meal_plan_id"
  end

  create_table "meal_plans", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "week_start_date"
    t.boolean "ai_generated"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meal_plans_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "meal_type"
    t.date "date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "progress_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.decimal "weight"
    t.decimal "body_fat_percentage"
    t.decimal "chest"
    t.decimal "waist"
    t.decimal "hips"
    t.decimal "arms"
    t.decimal "thighs"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_progress_logs_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.text "description"
    t.text "instructions"
    t.integer "prep_time"
    t.integer "cook_time"
    t.integer "servings"
    t.integer "calories"
    t.decimal "protein"
    t.decimal "carbs"
    t.decimal "fat"
    t.string "image_url"
    t.boolean "ai_generated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "height"
    t.decimal "weight"
    t.integer "age"
    t.string "gender"
    t.string "fitness_goal"
    t.string "activity_level"
    t.integer "daily_calorie_goal"
    t.integer "protein_goal"
    t.integer "carb_goal"
    t.integer "fat_goal"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.integer "workout_id", null: false
    t.integer "exercise_id", null: false
    t.integer "sets"
    t.integer "reps"
    t.decimal "weight"
    t.integer "duration_seconds"
    t.integer "rest_seconds"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_id"], name: "index_workout_exercises_on_workout_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.date "scheduled_date"
    t.datetime "completed_at"
    t.integer "duration_minutes"
    t.integer "calories_burned"
    t.text "notes"
    t.boolean "ai_generated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workouts_on_user_id"
  end

  add_foreign_key "ai_conversations", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "meal_foods", "foods"
  add_foreign_key "meal_foods", "meals"
  add_foreign_key "meal_plan_days", "meal_plans"
  add_foreign_key "meal_plan_days", "recipes", column: "breakfast_recipe_id"
  add_foreign_key "meal_plan_days", "recipes", column: "dinner_recipe_id"
  add_foreign_key "meal_plan_days", "recipes", column: "lunch_recipe_id"
  add_foreign_key "meal_plans", "users"
  add_foreign_key "meals", "users"
  add_foreign_key "progress_logs", "users"
  add_foreign_key "recipes", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workouts"
  add_foreign_key "workouts", "users"
end
