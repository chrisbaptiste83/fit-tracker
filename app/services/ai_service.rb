class AiService
  def initialize(user)
    @user = user
    @client = Anthropic::Client.new
  end

  def generate_workout(preferences)
    prompt = build_workout_prompt(preferences)

    response = call_claude(prompt, system: workout_system_prompt)

    parse_workout_response(response)
  rescue => e
    Rails.logger.error("AI Workout Generation Error: #{e.message}")
    { success: false, error: e.message }
  end

  def suggest_meals(preferences)
    prompt = build_meal_suggestion_prompt(preferences)

    response = call_claude(prompt, system: nutrition_system_prompt)

    parse_meal_suggestions(response)
  rescue => e
    Rails.logger.error("AI Meal Suggestion Error: #{e.message}")
    []
  end

  def analyze_progress(logs)
    prompt = build_progress_prompt(logs)

    response = call_claude(prompt, system: progress_system_prompt)

    {
      analysis: response,
      generated_at: Time.current
    }
  rescue => e
    Rails.logger.error("AI Progress Analysis Error: #{e.message}")
    { analysis: "Unable to analyze progress at this time.", error: e.message }
  end

  def chat(message, context)
    system_prompt = case context
    when "workout" then workout_system_prompt
    when "nutrition" then nutrition_system_prompt
    else general_system_prompt
    end

    call_claude(message, system: system_prompt)
  rescue => e
    Rails.logger.error("AI Chat Error: #{e.message}")
    "I apologize, but I'm having trouble responding right now. Please try again."
  end

  def parse_food_log(natural_language)
    prompt = <<~PROMPT
      Parse the following food log entry and extract the foods with estimated nutritional information.
      Return a JSON array of foods with: name, quantity, unit, estimated_calories, estimated_protein, estimated_carbs, estimated_fat.

      Entry: "#{natural_language}"

      Return ONLY valid JSON, no explanation.
    PROMPT

    response = call_claude(prompt, system: nutrition_system_prompt)

    JSON.parse(response)
  rescue JSON::ParserError => e
    Rails.logger.error("AI Food Parse Error: #{e.message}")
    []
  rescue => e
    Rails.logger.error("AI Food Parse Error: #{e.message}")
    []
  end

  private

  def call_claude(prompt, system: nil)
    messages = [{ role: "user", content: prompt }]

    response = @client.messages.create(
      model: "claude-sonnet-4-20250514",
      max_tokens: 2048,
      system: system,
      messages: messages
    )

    response.content.first.text
  end

  def build_workout_prompt(preferences)
    <<~PROMPT
      Create a #{preferences[:duration]}-minute workout focused on #{preferences[:focus]}.
      Equipment available: #{preferences[:equipment] || 'bodyweight only'}
      Difficulty level: #{preferences[:difficulty] || 'intermediate'}

      User profile:
      - Fitness goal: #{@user.fitness_goal}
      - Activity level: #{@user.activity_level}

      Return a JSON object with:
      {
        "name": "Workout name",
        "duration": minutes,
        "notes": "Brief description",
        "exercises": [
          {
            "name": "Exercise name",
            "sets": number,
            "reps": number,
            "duration_seconds": number (for timed exercises),
            "rest_seconds": number
          }
        ]
      }

      Return ONLY valid JSON, no explanation.
    PROMPT
  end

  def build_meal_suggestion_prompt(preferences)
    <<~PROMPT
      Suggest 3 #{preferences[:meal_type]} options for someone with these goals:
      - Daily calorie goal: #{@user.daily_calorie_goal || 2000}
      - Calories remaining today: #{preferences[:calories_remaining]}
      - Dietary preferences: #{preferences[:preferences] || 'none specified'}

      For each meal, provide:
      - Name
      - Brief description
      - Estimated calories, protein, carbs, fat
      - Quick recipe or preparation steps

      Return as JSON array.
    PROMPT
  end

  def build_progress_prompt(logs)
    weight_data = logs.where.not(weight: nil).pluck(:date, :weight)

    <<~PROMPT
      Analyze this fitness progress data and provide insights:

      User Profile:
      - Goal: #{@user.fitness_goal}
      - Starting weight: #{weight_data.first&.last || 'unknown'}
      - Current weight: #{weight_data.last&.last || 'unknown'}
      - Weight history (last 30 days): #{weight_data.to_json}

      Provide:
      1. Summary of progress
      2. Trend analysis
      3. Recommendations for improvement
      4. Motivation and encouragement

      Keep the response concise and actionable.
    PROMPT
  end

  def parse_workout_response(response)
    workout_data = JSON.parse(response)
    { success: true, workout: workout_data.deep_symbolize_keys }
  rescue JSON::ParserError
    { success: false, error: "Could not parse workout data" }
  end

  def parse_meal_suggestions(response)
    JSON.parse(response)
  rescue JSON::ParserError
    []
  end

  def workout_system_prompt
    <<~SYSTEM
      You are a certified personal trainer and fitness expert. You create safe, effective workout plans tailored to individual goals and fitness levels.
      Always consider proper form, adequate rest, and progressive overload principles.
      Respond only with valid JSON when asked for structured data.
    SYSTEM
  end

  def nutrition_system_prompt
    <<~SYSTEM
      You are a registered dietitian and nutrition expert. You provide evidence-based nutrition advice and meal suggestions.
      Consider macronutrient balance, caloric needs, and dietary preferences.
      Respond only with valid JSON when asked for structured data.
    SYSTEM
  end

  def progress_system_prompt
    <<~SYSTEM
      You are a supportive fitness coach analyzing progress data. Provide encouraging, actionable insights based on the data.
      Focus on positive trends while addressing areas for improvement constructively.
    SYSTEM
  end

  def general_system_prompt
    <<~SYSTEM
      You are FitTrack AI, a friendly and knowledgeable fitness and nutrition assistant.
      You help users with workout planning, nutrition tracking, and achieving their fitness goals.
      Be encouraging, supportive, and provide practical advice.
      Keep responses concise and actionable.
    SYSTEM
  end
end
