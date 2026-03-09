puts "Clearing existing data..."
WorkoutExercise.delete_all
Workout.delete_all
MealFood.delete_all
Meal.delete_all
MealPlanDay.delete_all
MealPlan.delete_all
Recipe.delete_all
ProgressLog.delete_all
Goal.delete_all
AiConversation.delete_all
Session.delete_all
Exercise.delete_all
Food.delete_all
User.delete_all
puts "Done."

# ─── USERS ────────────────────────────────────────────────────────────────────

puts "Creating users..."
alex = User.create!(
  email_address: "alex.carter@example.com",
  password: "password",
  height: 180,
  weight: 84,
  age: 28,
  gender: "male",
  fitness_goal: "build_muscle",
  activity_level: "moderate",
  daily_calorie_goal: 2800,
  protein_goal: 180,
  carb_goal: 320,
  fat_goal: 75
)

sarah = User.create!(
  email_address: "sarah.m@example.com",
  password: "password",
  height: 165,
  weight: 67,
  age: 34,
  gender: "female",
  fitness_goal: "lose_weight",
  activity_level: "active",
  daily_calorie_goal: 1700,
  protein_goal: 130,
  carb_goal: 170,
  fat_goal: 50
)

marcus = User.create!(
  email_address: "marcus.r@example.com",
  password: "password",
  height: 178,
  weight: 79,
  age: 42,
  gender: "male",
  fitness_goal: "maintain",
  activity_level: "very_active",
  daily_calorie_goal: 2600,
  protein_goal: 140,
  carb_goal: 300,
  fat_goal: 80
)

jordan = User.create!(
  email_address: "jordan.k@example.com",
  password: "password",
  height: 170,
  weight: 63,
  age: 25,
  gender: "other",
  fitness_goal: "endurance",
  activity_level: "active",
  daily_calorie_goal: 2400,
  protein_goal: 120,
  carb_goal: 320,
  fat_goal: 65
)

users = [alex, sarah, marcus, jordan]
puts "Created #{users.count} users."

# ─── EXERCISES ────────────────────────────────────────────────────────────────

puts "Creating exercises..."
exercises = [
  # Strength — Chest
  { name: "Barbell Bench Press", description: "Classic compound chest press using a barbell on a flat bench.", category: "strength", muscle_group: "chest", difficulty: "intermediate", calories_per_minute: 6, equipment_needed: "Barbell, bench", instructions: "Lie flat on bench. Grip barbell slightly wider than shoulder-width. Lower to chest, press back up explosively." },
  { name: "Dumbbell Flyes", description: "Isolation exercise that stretches and squeezes the chest.", category: "strength", muscle_group: "chest", difficulty: "beginner", calories_per_minute: 4, equipment_needed: "Dumbbells, bench", instructions: "Lie on bench with dumbbells above chest. Lower arms out wide in an arc, return to start." },
  { name: "Push-Up", description: "Bodyweight chest exercise requiring no equipment.", category: "strength", muscle_group: "chest", difficulty: "beginner", calories_per_minute: 5, equipment_needed: "None", instructions: "Start in plank position. Lower chest to floor, push back up. Keep core tight throughout." },

  # Strength — Back
  { name: "Deadlift", description: "King of compound lifts. Works the entire posterior chain.", category: "strength", muscle_group: "back", difficulty: "advanced", calories_per_minute: 8, equipment_needed: "Barbell", instructions: "Stand with bar over feet. Hinge at hips, grip bar. Drive through heels, keep back flat, lock out at top." },
  { name: "Pull-Up", description: "Upper body pulling movement using bodyweight.", category: "strength", muscle_group: "back", difficulty: "intermediate", calories_per_minute: 6, equipment_needed: "Pull-up bar", instructions: "Hang from bar with overhand grip. Pull until chin clears bar, lower with control." },
  { name: "Seated Cable Row", description: "Machine-based horizontal rowing movement for mid-back thickness.", category: "strength", muscle_group: "back", difficulty: "beginner", calories_per_minute: 4, equipment_needed: "Cable machine", instructions: "Sit upright, grip handle, row to abdomen squeezing shoulder blades. Extend arms fully before repeating." },

  # Strength — Legs
  { name: "Barbell Back Squat", description: "Foundational lower body compound movement.", category: "strength", muscle_group: "legs", difficulty: "advanced", calories_per_minute: 8, equipment_needed: "Barbell, squat rack", instructions: "Bar on upper traps. Feet shoulder-width, toes slightly out. Descend until thighs parallel, drive back up." },
  { name: "Romanian Deadlift", description: "Hip-hinge movement targeting hamstrings and glutes.", category: "strength", muscle_group: "legs", difficulty: "intermediate", calories_per_minute: 6, equipment_needed: "Barbell or Dumbbells", instructions: "Stand with weight. Hinge at hips, lowering weight along legs until you feel a hamstring stretch, return to standing." },
  { name: "Walking Lunges", description: "Unilateral leg exercise for strength and balance.", category: "strength", muscle_group: "legs", difficulty: "beginner", calories_per_minute: 5, equipment_needed: "Dumbbells (optional)", instructions: "Step forward into lunge, lower back knee toward floor. Step through with trailing foot and repeat." },
  { name: "Leg Press", description: "Machine-based quad-dominant compound movement.", category: "strength", muscle_group: "legs", difficulty: "beginner", calories_per_minute: 5, equipment_needed: "Leg press machine", instructions: "Sit in machine with feet on platform. Lower weight until knees near chest, press back to start without locking out." },

  # Strength — Shoulders
  { name: "Overhead Press", description: "Compound shoulder press with barbell or dumbbells.", category: "strength", muscle_group: "shoulders", difficulty: "intermediate", calories_per_minute: 6, equipment_needed: "Barbell or Dumbbells", instructions: "Stand with bar at shoulder height. Press overhead to full extension, lower with control." },
  { name: "Lateral Raises", description: "Isolation exercise for side deltoids.", category: "strength", muscle_group: "shoulders", difficulty: "beginner", calories_per_minute: 3, equipment_needed: "Dumbbells", instructions: "Hold dumbbells at sides. Raise arms out to shoulder height, lower slowly. Avoid shrugging." },

  # Strength — Arms
  { name: "Barbell Curl", description: "Classic bicep isolation exercise.", category: "strength", muscle_group: "arms", difficulty: "beginner", calories_per_minute: 3, equipment_needed: "Barbell", instructions: "Stand with bar at hips, underhand grip. Curl to shoulder height squeezing biceps, lower slowly." },
  { name: "Tricep Dips", description: "Bodyweight or weighted tricep compound movement.", category: "strength", muscle_group: "arms", difficulty: "intermediate", calories_per_minute: 5, equipment_needed: "Parallel bars or bench", instructions: "Support body on bars. Lower until upper arms parallel to floor, press back up." },

  # Strength — Core
  { name: "Plank", description: "Isometric core stability exercise.", category: "strength", muscle_group: "core", difficulty: "beginner", calories_per_minute: 3, equipment_needed: "None", instructions: "Hold push-up position on forearms. Keep body in straight line, breathe steadily. Hold for time." },
  { name: "Cable Crunch", description: "Weighted core flexion exercise.", category: "strength", muscle_group: "core", difficulty: "intermediate", calories_per_minute: 4, equipment_needed: "Cable machine", instructions: "Kneel facing cable. Hold rope at head. Crunch down contracting abs, do not pull with arms." },

  # Cardio
  { name: "Treadmill Running", description: "Steady-state or interval cardio on a treadmill.", category: "cardio", muscle_group: "full_body", difficulty: "intermediate", calories_per_minute: 11, equipment_needed: "Treadmill", instructions: "Warm up at walk pace, increase to target pace. Maintain good posture, land midfoot." },
  { name: "Rowing Machine", description: "Full-body low-impact cardio and strength endurance.", category: "cardio", muscle_group: "full_body", difficulty: "intermediate", calories_per_minute: 10, equipment_needed: "Rowing machine (erg)", instructions: "Drive with legs first, then lean back, then pull handle to lower chest. Return in reverse order." },
  { name: "Jump Rope", description: "High-intensity cardio requiring only a rope.", category: "cardio", muscle_group: "full_body", difficulty: "beginner", calories_per_minute: 12, equipment_needed: "Jump rope", instructions: "Jump with both feet, land softly on balls of feet. Keep elbows close to body, wrists drive the rope." },
  { name: "Cycling", description: "Low-impact cardio on stationary or road bike.", category: "cardio", muscle_group: "legs", difficulty: "beginner", calories_per_minute: 9, equipment_needed: "Bike or stationary bike", instructions: "Set saddle height so knee is slightly bent at bottom of pedal stroke. Maintain cadence of 80-100 RPM." },
  { name: "Stair Climber", description: "Cardiovascular machine simulating stair climbing.", category: "cardio", muscle_group: "legs", difficulty: "intermediate", calories_per_minute: 10, equipment_needed: "Stair climber machine", instructions: "Step at a steady pace, push through whole foot. Keep upright posture, avoid leaning on rails." },

  # Flexibility / Mobility
  { name: "Yoga Flow", description: "Dynamic sequence linking breath to movement for flexibility and calm.", category: "flexibility", muscle_group: "full_body", difficulty: "beginner", calories_per_minute: 3, equipment_needed: "Yoga mat", instructions: "Flow through sun salutations, warrior sequences, and finishing poses. Breathe through each transition." },
  { name: "Hip Flexor Stretch", description: "Static stretch targeting the iliopsoas and hip flexors.", category: "flexibility", muscle_group: "legs", difficulty: "beginner", calories_per_minute: 1, equipment_needed: "None", instructions: "Kneel on one knee. Push hips forward gently until stretch felt in front of hip. Hold 30–45 sec each side." },
  { name: "Foam Roll — Upper Back", description: "Self-myofascial release for thoracic spine and upper back.", category: "flexibility", muscle_group: "back", difficulty: "beginner", calories_per_minute: 2, equipment_needed: "Foam roller", instructions: "Place roller under upper back. Support head with hands. Extend over roller and roll slowly up and down." }
].map { |attrs| Exercise.create!(attrs) }
puts "Created #{exercises.count} exercises."

# ─── FOODS ────────────────────────────────────────────────────────────────────

puts "Creating foods..."
foods = [
  # Proteins
  { name: "Chicken Breast", brand: nil, serving_size: 100, serving_unit: "g", calories: 165, protein: 31.0, carbs: 0.0, fat: 3.6, fiber: 0.0 },
  { name: "Salmon Fillet", brand: nil, serving_size: 100, serving_unit: "g", calories: 208, protein: 20.0, carbs: 0.0, fat: 13.0, fiber: 0.0 },
  { name: "Ground Beef 93%", brand: nil, serving_size: 100, serving_unit: "g", calories: 172, protein: 26.0, carbs: 0.0, fat: 7.0, fiber: 0.0 },
  { name: "Eggs", brand: nil, serving_size: 1, serving_unit: "large egg", calories: 70, protein: 6.0, carbs: 0.5, fat: 5.0, fiber: 0.0 },
  { name: "Greek Yogurt", brand: "Chobani", serving_size: 170, serving_unit: "g", calories: 100, protein: 17.0, carbs: 6.0, fat: 0.7, fiber: 0.0 },
  { name: "Cottage Cheese", brand: nil, serving_size: 100, serving_unit: "g", calories: 98, protein: 11.0, carbs: 3.4, fat: 4.3, fiber: 0.0 },
  { name: "Whey Protein", brand: "Optimum Nutrition", serving_size: 30, serving_unit: "g scoop", calories: 120, protein: 24.0, carbs: 3.0, fat: 1.5, fiber: 0.0 },
  { name: "Tuna in Water", brand: "StarKist", serving_size: 85, serving_unit: "g (1 can)", calories: 100, protein: 22.0, carbs: 0.0, fat: 0.5, fiber: 0.0 },
  { name: "Shrimp", brand: nil, serving_size: 100, serving_unit: "g", calories: 99, protein: 24.0, carbs: 0.2, fat: 0.3, fiber: 0.0 },
  { name: "Turkey Breast", brand: nil, serving_size: 100, serving_unit: "g", calories: 135, protein: 30.0, carbs: 0.0, fat: 1.0, fiber: 0.0 },

  # Carbs / Grains
  { name: "Brown Rice (cooked)", brand: nil, serving_size: 195, serving_unit: "g (1 cup)", calories: 216, protein: 5.0, carbs: 45.0, fat: 1.8, fiber: 3.5 },
  { name: "White Rice (cooked)", brand: nil, serving_size: 186, serving_unit: "g (1 cup)", calories: 242, protein: 4.4, carbs: 53.0, fat: 0.4, fiber: 0.6 },
  { name: "Oatmeal (dry)", brand: "Quaker", serving_size: 40, serving_unit: "g (½ cup)", calories: 150, protein: 5.0, carbs: 27.0, fat: 3.0, fiber: 4.0 },
  { name: "Sweet Potato", brand: nil, serving_size: 130, serving_unit: "g (1 medium)", calories: 112, protein: 2.1, carbs: 26.0, fat: 0.1, fiber: 3.9 },
  { name: "Whole Wheat Bread", brand: "Dave's Killer Bread", serving_size: 45, serving_unit: "g (2 slices)", calories: 110, protein: 5.0, carbs: 22.0, fat: 2.0, fiber: 3.0 },
  { name: "Quinoa (cooked)", brand: nil, serving_size: 185, serving_unit: "g (1 cup)", calories: 222, protein: 8.1, carbs: 39.0, fat: 3.6, fiber: 5.2 },
  { name: "Banana", brand: nil, serving_size: 118, serving_unit: "g (1 medium)", calories: 105, protein: 1.3, carbs: 27.0, fat: 0.4, fiber: 3.1 },
  { name: "Blueberries", brand: nil, serving_size: 148, serving_unit: "g (1 cup)", calories: 84, protein: 1.1, carbs: 21.0, fat: 0.5, fiber: 3.6 },
  { name: "Apple", brand: nil, serving_size: 182, serving_unit: "g (1 medium)", calories: 95, protein: 0.5, carbs: 25.0, fat: 0.3, fiber: 4.4 },
  { name: "Pasta (cooked)", brand: nil, serving_size: 140, serving_unit: "g (1 cup)", calories: 220, protein: 8.0, carbs: 43.0, fat: 1.3, fiber: 2.5 },

  # Fats
  { name: "Avocado", brand: nil, serving_size: 150, serving_unit: "g (1 medium)", calories: 240, protein: 3.0, carbs: 12.0, fat: 22.0, fiber: 10.0 },
  { name: "Almond Butter", brand: "Justin's", serving_size: 32, serving_unit: "g (2 tbsp)", calories: 190, protein: 7.0, carbs: 7.0, fat: 16.0, fiber: 3.0 },
  { name: "Olive Oil", brand: nil, serving_size: 14, serving_unit: "g (1 tbsp)", calories: 119, protein: 0.0, carbs: 0.0, fat: 14.0, fiber: 0.0 },
  { name: "Mixed Nuts", brand: nil, serving_size: 28, serving_unit: "g (1 oz)", calories: 173, protein: 5.0, carbs: 6.0, fat: 16.0, fiber: 2.0 },

  # Vegetables
  { name: "Broccoli", brand: nil, serving_size: 91, serving_unit: "g (1 cup)", calories: 31, protein: 2.6, carbs: 6.0, fat: 0.3, fiber: 2.4 },
  { name: "Spinach", brand: nil, serving_size: 30, serving_unit: "g (1 cup raw)", calories: 7, protein: 0.9, carbs: 1.1, fat: 0.1, fiber: 0.7 },
  { name: "Bell Pepper", brand: nil, serving_size: 119, serving_unit: "g (1 medium)", calories: 31, protein: 1.0, carbs: 7.2, fat: 0.3, fiber: 2.5 },
  { name: "Asparagus", brand: nil, serving_size: 134, serving_unit: "g (1 cup)", calories: 27, protein: 3.0, carbs: 5.2, fat: 0.2, fiber: 2.8 },

  # Dairy / Other
  { name: "Whole Milk", brand: nil, serving_size: 244, serving_unit: "g (1 cup)", calories: 149, protein: 8.0, carbs: 12.0, fat: 8.0, fiber: 0.0 },
  { name: "Mozzarella", brand: nil, serving_size: 28, serving_unit: "g (1 oz)", calories: 85, protein: 6.3, carbs: 0.6, fat: 6.3, fiber: 0.0 }
].map { |attrs| Food.create!(attrs) }
puts "Created #{foods.count} foods."

# ─── WORKOUTS ─────────────────────────────────────────────────────────────────

puts "Creating workouts and exercises..."

strength_exercises = exercises.select { |e| e.category_strength? }
cardio_exercises   = exercises.select { |e| e.category_cardio? }
chest_exercises    = exercises.select { |e| e.muscle_group_chest? }
back_exercises     = exercises.select { |e| e.muscle_group_back? }
leg_exercises      = exercises.select { |e| e.muscle_group_legs? }
shoulder_arm_exs   = exercises.select { |e| e.muscle_group_shoulders? || e.muscle_group_arms? }

bench_press  = exercises.find { |e| e.name == "Barbell Bench Press" }
squat        = exercises.find { |e| e.name == "Barbell Back Squat" }
deadlift     = exercises.find { |e| e.name == "Deadlift" }
ohp          = exercises.find { |e| e.name == "Overhead Press" }
pullup       = exercises.find { |e| e.name == "Pull-Up" }
rdl          = exercises.find { |e| e.name == "Romanian Deadlift" }
running      = exercises.find { |e| e.name == "Treadmill Running" }
rowing       = exercises.find { |e| e.name == "Rowing Machine" }
cycling      = exercises.find { |e| e.name == "Cycling" }
jump_rope    = exercises.find { |e| e.name == "Jump Rope" }
barbell_curl = exercises.find { |e| e.name == "Barbell Curl" }
tri_dips     = exercises.find { |e| e.name == "Tricep Dips" }
lateral_rai  = exercises.find { |e| e.name == "Lateral Raises" }
db_flyes     = exercises.find { |e| e.name == "Dumbbell Flyes" }
lunges       = exercises.find { |e| e.name == "Walking Lunges" }
plank        = exercises.find { |e| e.name == "Plank" }

def make_workout(user:, name:, days_ago:, duration:, calories:, exercise_sets:)
  date = days_ago.days.ago.to_date
  w = Workout.create!(
    user: user,
    name: name,
    scheduled_date: date,
    completed_at: days_ago.days.ago.change(hour: rand(6..20)),
    duration_minutes: duration,
    calories_burned: calories,
    ai_generated: false
  )
  exercise_sets.each_with_index do |(ex, sets, reps, weight_kg), idx|
    WorkoutExercise.create!(
      workout: w,
      exercise: ex,
      sets: sets,
      reps: reps,
      weight: weight_kg,
      rest_seconds: 90,
      order: idx + 1
    )
  end
  w
end

# Alex — 3x/week push/pull/legs over past 3 weeks
[
  [14, "Push Day A", 65, 480, [[bench_press, 4, 8, 90], [db_flyes, 3, 12, 22], [ohp, 3, 8, 55], [lateral_rai, 3, 15, 10], [tri_dips, 3, 12, nil]]],
  [12, "Pull Day A", 70, 520, [[deadlift, 4, 5, 140], [pullup, 4, 8, nil], [barbell_curl, 3, 12, 30], [plank, 3, nil, nil]]],
  [10, "Leg Day A", 75, 600, [[squat, 5, 5, 115], [rdl, 4, 8, 90], [lunges, 3, 12, 20]]],
  [7,  "Push Day B", 60, 460, [[bench_press, 4, 8, 92.5], [ohp, 3, 8, 57.5], [lateral_rai, 3, 15, 12], [tri_dips, 3, 12, nil]]],
  [5,  "Pull Day B", 65, 490, [[deadlift, 4, 5, 142.5], [pullup, 4, 9, nil], [barbell_curl, 3, 12, 32]]],
  [3,  "Leg Day B", 70, 570, [[squat, 5, 5, 117.5], [rdl, 4, 8, 92.5], [lunges, 3, 12, 22.5]]],
  [1,  "Push Day C", 65, 470, [[bench_press, 4, 8, 95], [db_flyes, 3, 12, 24], [ohp, 3, 8, 60], [lateral_rai, 3, 15, 12]]]
].each do |days_ago, name, dur, cal, ex_sets|
  make_workout(user: alex, name: name, days_ago: days_ago, duration: dur, calories: cal, exercise_sets: ex_sets)
end

# Sarah — cardio + light strength over past 2 weeks
[
  [13, "Morning Run", 40, 380, [[running, nil, nil, nil]]],
  [11, "Full Body Strength", 50, 320, [[lunges, 3, 15, 10], [bench_press, 3, 12, 35], [plank, 4, nil, nil], [squat, 3, 15, 30]]],
  [9,  "Cycling Session", 45, 400, [[cycling, nil, nil, nil]]],
  [7,  "Cardio + Core", 50, 420, [[running, nil, nil, nil], [plank, 4, nil, nil]]],
  [5,  "Strength Circuit", 55, 360, [[squat, 3, 15, 35], [lunges, 3, 15, 12], [bench_press, 3, 12, 37.5], [lateral_rai, 3, 15, 6]]],
  [3,  "Long Run", 55, 520, [[running, nil, nil, nil]]],
  [1,  "Jump Rope Interval", 30, 350, [[jump_rope, nil, nil, nil]]]
].each do |days_ago, name, dur, cal, ex_sets|
  make_workout(user: sarah, name: name, days_ago: days_ago, duration: dur, calories: cal, exercise_sets: ex_sets)
end

# Marcus — balanced athlete, 4x/week
[
  [13, "Rowing Endurance", 60, 600, [[rowing, nil, nil, nil]]],
  [11, "Heavy Compound Day", 80, 650, [[deadlift, 4, 4, 170], [squat, 4, 4, 145], [ohp, 4, 5, 80]]],
  [8,  "Cycling Endurance", 75, 680, [[cycling, nil, nil, nil]]],
  [6,  "Upper Body Power", 70, 530, [[bench_press, 4, 6, 110], [pullup, 4, 10, nil], [ohp, 3, 6, 80]]],
  [4,  "Rowing Intervals", 50, 550, [[rowing, nil, nil, nil]]],
  [2,  "Full Body Strength", 75, 590, [[deadlift, 3, 5, 172.5], [squat, 3, 5, 147.5], [bench_press, 3, 6, 112.5]]]
].each do |days_ago, name, dur, cal, ex_sets|
  make_workout(user: marcus, name: name, days_ago: days_ago, duration: dur, calories: cal, exercise_sets: ex_sets)
end

# Jordan — runner + cross-training
[
  [14, "Easy 5K Run", 30, 300, [[running, nil, nil, nil]]],
  [12, "Cross-Training", 45, 380, [[rowing, nil, nil, nil], [jump_rope, nil, nil, nil]]],
  [10, "Tempo Run", 40, 410, [[running, nil, nil, nil]]],
  [7,  "Leg Strength", 50, 360, [[squat, 3, 12, 50], [rdl, 3, 12, 45], [lunges, 3, 15, 12]]],
  [5,  "Long Run", 65, 640, [[running, nil, nil, nil]]],
  [3,  "Recovery Cycling", 40, 320, [[cycling, nil, nil, nil]]],
  [1,  "Intervals", 35, 420, [[running, nil, nil, nil], [jump_rope, nil, nil, nil]]]
].each do |days_ago, name, dur, cal, ex_sets|
  make_workout(user: jordan, name: name, days_ago: days_ago, duration: dur, calories: cal, exercise_sets: ex_sets)
end

puts "Workouts created."

# ─── MEALS ────────────────────────────────────────────────────────────────────

puts "Creating meals..."

chicken  = foods.find { |f| f.name == "Chicken Breast" }
rice     = foods.find { |f| f.name == "Brown Rice (cooked)" }
eggs     = foods.find { |f| f.name == "Eggs" }
oats     = foods.find { |f| f.name == "Oatmeal (dry)" }
banana   = foods.find { |f| f.name == "Banana" }
greek_yo = foods.find { |f| f.name == "Greek Yogurt" }
sweet_po = foods.find { |f| f.name == "Sweet Potato" }
salmon   = foods.find { |f| f.name == "Salmon Fillet" }
broccoli = foods.find { |f| f.name == "Broccoli" }
whey     = foods.find { |f| f.name == "Whey Protein" }
alm_but  = foods.find { |f| f.name == "Almond Butter" }
avocado  = foods.find { |f| f.name == "Avocado" }
turkey   = foods.find { |f| f.name == "Turkey Breast" }
quinoa   = foods.find { |f| f.name == "Quinoa (cooked)" }
tuna     = foods.find { |f| f.name == "Tuna in Water" }
blueberr = foods.find { |f| f.name == "Blueberries" }
spinach  = foods.find { |f| f.name == "Spinach" }
pasta    = foods.find { |f| f.name == "Pasta (cooked)" }
cottage  = foods.find { |f| f.name == "Cottage Cheese" }
apple    = foods.find { |f| f.name == "Apple" }

def add_meal(user:, date:, meal_type:, food_servings:)
  meal = Meal.create!(user: user, date: date, meal_type: meal_type)
  food_servings.each do |food, servings|
    MealFood.create!(meal: meal, food: food, servings: servings)
  end
end

# Alex — bulking meal plan (high cal, high protein)
7.times do |i|
  date = i.days.ago.to_date
  add_meal(user: alex, date: date, meal_type: "breakfast", food_servings: [[oats, 2], [eggs, 4], [banana, 1], [greek_yo, 1]])
  add_meal(user: alex, date: date, meal_type: "lunch", food_servings: [[chicken, 2.5], [rice, 1.5], [broccoli, 2]])
  add_meal(user: alex, date: date, meal_type: "snack", food_servings: [[whey, 1], [alm_but, 1], [apple, 1]])
  add_meal(user: alex, date: date, meal_type: "dinner", food_servings: [[salmon, 2], [sweet_po, 1], [spinach, 2]])
end

# Sarah — calorie deficit, nutrient-dense
7.times do |i|
  date = i.days.ago.to_date
  add_meal(user: sarah, date: date, meal_type: "breakfast", food_servings: [[greek_yo, 1], [blueberr, 1], [oats, 1]])
  add_meal(user: sarah, date: date, meal_type: "lunch", food_servings: [[turkey, 1.5], [quinoa, 1], [broccoli, 2], [spinach, 2]])
  add_meal(user: sarah, date: date, meal_type: "snack", food_servings: [[cottage, 1], [apple, 1]])
  add_meal(user: sarah, date: date, meal_type: "dinner", food_servings: [[salmon, 1.5], [sweet_po, 1], [broccoli, 2]])
end

# Marcus — maintenance, varied
7.times do |i|
  date = i.days.ago.to_date
  add_meal(user: marcus, date: date, meal_type: "breakfast", food_servings: [[eggs, 3], [oats, 1.5], [banana, 1]])
  add_meal(user: marcus, date: date, meal_type: "lunch", food_servings: [[tuna, 1.5], [quinoa, 1], [avocado, 0.5]])
  add_meal(user: marcus, date: date, meal_type: "dinner", food_servings: [[chicken, 2], [pasta, 1], [spinach, 2]])
end

# Jordan — endurance fueling, carb-forward
7.times do |i|
  date = i.days.ago.to_date
  add_meal(user: jordan, date: date, meal_type: "breakfast", food_servings: [[oats, 2], [banana, 1], [alm_but, 1]])
  add_meal(user: jordan, date: date, meal_type: "lunch", food_servings: [[chicken, 1.5], [rice, 2], [broccoli, 1]])
  add_meal(user: jordan, date: date, meal_type: "snack", food_servings: [[banana, 1], [greek_yo, 1]])
  add_meal(user: jordan, date: date, meal_type: "dinner", food_servings: [[salmon, 1.5], [sweet_po, 1.5], [spinach, 2]])
end

puts "Meals created."

# ─── PROGRESS LOGS ────────────────────────────────────────────────────────────

puts "Creating progress logs..."

# Alex — gaining muscle, slow weight increase over 3 months
[
  [90, 82.0, 18.0, 99.0, 81.0, 96.0, 34.0, 57.0, "Starting my bulk. Feeling motivated."],
  [75, 82.5, 17.5, 99.5, 80.5, 96.0, 34.5, 57.5, "Strength going up. Sleep has been great."],
  [60, 83.0, 17.2, 100.0, 80.0, 96.5, 35.0, 58.0, nil],
  [45, 83.5, 16.8, 100.5, 79.5, 96.0, 35.5, 58.5, "Hit 90kg squat today. Big milestone."],
  [30, 83.8, 16.5, 101.0, 79.0, 96.5, 36.0, 59.0, nil],
  [15, 84.0, 16.2, 101.5, 78.5, 96.0, 36.5, 59.5, "Looking noticeably fuller. Happy with progress."],
  [0,  84.2, 15.9, 102.0, 78.0, 96.0, 37.0, 60.0, "Bench hit 95kg for 3 reps. PB."]
].each do |days_ago, weight, bf, chest, waist, hips, arms, thighs, notes|
  ProgressLog.create!(user: alex, date: days_ago.days.ago.to_date, weight: weight, body_fat_percentage: bf, chest: chest, waist: waist, hips: hips, arms: arms, thighs: thighs, notes: notes)
end

# Sarah — losing weight, measurements shrinking
[
  [90, 69.5, 29.0, 91.0, 76.0, 99.0, 30.0, 56.0, "Starting my weight loss journey. Ready to commit."],
  [75, 68.8, 28.5, 90.5, 75.0, 98.5, 29.5, 55.5, "Down 0.7kg. Feeling good about the deficit."],
  [60, 68.0, 28.0, 90.0, 74.5, 98.0, 29.5, 55.0, "Clothes starting to fit differently!"],
  [45, 67.5, 27.5, 89.5, 73.5, 97.5, 29.0, 54.5, "Hit a plateau this week but staying consistent."],
  [30, 67.0, 27.0, 89.0, 73.0, 97.0, 29.0, 54.0, nil],
  [15, 66.5, 26.5, 88.5, 72.0, 96.5, 28.5, 53.5, "People are noticing. So motivating!"],
  [0,  65.8, 26.0, 88.0, 71.5, 96.0, 28.5, 53.0, "Down 3.5kg since starting. Halfway to goal."]
].each do |days_ago, weight, bf, chest, waist, hips, arms, thighs, notes|
  ProgressLog.create!(user: sarah, date: days_ago.days.ago.to_date, weight: weight, body_fat_percentage: bf, chest: chest, waist: waist, hips: hips, arms: arms, thighs: thighs, notes: notes)
end

# Marcus — stable maintenance, gradual body recomposition
[
  [90, 79.5, 14.5, 102.0, 80.0, 98.0, 37.5, 60.0, "Maintaining after a hard training block."],
  [60, 79.2, 14.3, 102.0, 79.5, 98.0, 37.5, 60.5, "Feeling strong. Rowing PB this month."],
  [30, 79.0, 14.0, 102.5, 79.5, 98.0, 38.0, 60.5, "Body comp shifting even at same weight."],
  [0,  79.0, 13.8, 103.0, 79.0, 98.0, 38.0, 61.0, "Lean and strong. Happy with where things are at."]
].each do |days_ago, weight, bf, chest, waist, hips, arms, thighs, notes|
  ProgressLog.create!(user: marcus, date: days_ago.days.ago.to_date, weight: weight, body_fat_percentage: bf, chest: chest, waist: waist, hips: hips, arms: arms, thighs: thighs, notes: notes)
end

# Jordan — runner, gradual weight drop + endurance gains
[
  [90, 65.0, 19.0, 85.0, 69.0, 91.0, 27.0, 52.0, "Starting a 10K training block."],
  [60, 64.0, 18.5, 85.0, 68.0, 90.5, 27.0, 52.0, "Mileage up to 40k/week. Feeling fit."],
  [30, 63.5, 18.0, 85.0, 67.5, 90.0, 27.5, 52.5, "Tempo pace improving week over week."],
  [0,  62.8, 17.5, 85.0, 67.0, 90.0, 27.5, 52.5, "Ready for race day next month!"]
].each do |days_ago, weight, bf, chest, waist, hips, arms, thighs, notes|
  ProgressLog.create!(user: jordan, date: days_ago.days.ago.to_date, weight: weight, body_fat_percentage: bf, chest: chest, waist: waist, hips: hips, arms: arms, thighs: thighs, notes: notes)
end

puts "Progress logs created."

# ─── GOALS ────────────────────────────────────────────────────────────────────

puts "Creating goals..."

Goal.create!(user: alex, goal_type: "weight", target_value: 88, current_value: 84.2, unit: "kg", start_date: 90.days.ago.to_date, target_date: 90.days.from_now.to_date, description: "Reach 88kg lean body weight by end of bulk phase.")
Goal.create!(user: alex, goal_type: "strength", target_value: 120, current_value: 95, unit: "kg", start_date: 60.days.ago.to_date, target_date: 60.days.from_now.to_date, description: "Bench press 120kg for a clean single rep.")
Goal.create!(user: alex, goal_type: "habit", target_value: 7, current_value: 6, unit: "days/week", start_date: 30.days.ago.to_date, target_date: 30.days.from_now.to_date, description: "Hit daily protein goal of 180g every day of the week.")

Goal.create!(user: sarah, goal_type: "weight", target_value: 62, current_value: 65.8, unit: "kg", start_date: 90.days.ago.to_date, target_date: 60.days.from_now.to_date, description: "Reach 62kg through consistent deficit and exercise.")
Goal.create!(user: sarah, goal_type: "nutrition", target_value: 130, current_value: 115, unit: "g protein/day", start_date: 30.days.ago.to_date, target_date: 30.days.from_now.to_date, description: "Consistently hit 130g protein daily to preserve muscle during deficit.")
Goal.create!(user: sarah, goal_type: "habit", target_value: 5, current_value: 5, unit: "workouts/week", start_date: 30.days.ago.to_date, target_date: 30.days.from_now.to_date, description: "Train 5 days a week without missing.", completed_at: Time.current)

Goal.create!(user: marcus, goal_type: "strength", target_value: 200, current_value: 172.5, unit: "kg", start_date: 60.days.ago.to_date, target_date: 60.days.from_now.to_date, description: "Pull 200kg deadlift.")
Goal.create!(user: marcus, goal_type: "habit", target_value: 4, current_value: 4, unit: "sessions/week", start_date: 30.days.ago.to_date, target_date: 30.days.from_now.to_date, description: "Maintain 4 training sessions per week consistently.", completed_at: Time.current)

Goal.create!(user: jordan, goal_type: "habit", target_value: 50, current_value: 42, unit: "km/week", start_date: 30.days.ago.to_date, target_date: 30.days.from_now.to_date, description: "Build weekly running volume to 50km.")
Goal.create!(user: jordan, goal_type: "weight", target_value: 61, current_value: 62.8, unit: "kg", start_date: 60.days.ago.to_date, target_date: 30.days.from_now.to_date, description: "Race weight target of 61kg before the 10K.")

puts "Goals created."

puts "\nSeed complete!"
puts "  Users: #{User.count}"
puts "  Exercises: #{Exercise.count}"
puts "  Foods: #{Food.count}"
puts "  Workouts: #{Workout.count}"
puts "  Meals: #{Meal.count}"
puts "  Progress logs: #{ProgressLog.count}"
puts "  Goals: #{Goal.count}"
