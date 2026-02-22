module Ai
  class AssistantController < ApplicationController
    def index
      @conversation = current_user.ai_conversations.find_or_create_by(context: "general")
    end

    def chat
      @conversation = current_user.ai_conversations.find_or_create_by(context: params[:context] || "general")
      message = params[:message]

      @conversation.add_message(role: "user", content: message)

      response = AiService.new(current_user).chat(message, @conversation.context)

      @conversation.add_message(role: "assistant", content: response)

      respond_to do |format|
        format.turbo_stream
        format.json { render json: { response: response } }
      end
    end

    def generate_workout
      preferences = {
        duration: params[:duration].to_i,
        focus: params[:focus],
        equipment: params[:equipment],
        difficulty: params[:difficulty]
      }

      result = AiService.new(current_user).generate_workout(preferences)

      if result[:success]
        @workout = current_user.workouts.create!(
          name: result[:workout][:name],
          scheduled_date: Date.current,
          duration_minutes: result[:workout][:duration],
          ai_generated: true,
          notes: result[:workout][:notes]
        )

        result[:workout][:exercises].each_with_index do |ex, index|
          exercise = Exercise.find_by(name: ex[:name]) || Exercise.first
          if exercise
            @workout.workout_exercises.create!(
              exercise: exercise,
              sets: ex[:sets],
              reps: ex[:reps],
              duration_seconds: ex[:duration_seconds],
              rest_seconds: ex[:rest_seconds],
              order: index + 1
            )
          end
        end

        redirect_to @workout, notice: "AI generated your personalized workout!"
      else
        redirect_to workouts_path, alert: "Could not generate workout. Please try again."
      end
    end

    def suggest_meals
      preferences = {
        meal_type: params[:meal_type],
        calories_remaining: params[:calories_remaining].to_i,
        preferences: params[:preferences]
      }

      result = AiService.new(current_user).suggest_meals(preferences)

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("meal_suggestions", partial: "ai/meal_suggestions", locals: { suggestions: result }) }
        format.json { render json: result }
      end
    end

    def parse_food
      text = params[:text]
      result = AiService.new(current_user).parse_food_log(text)

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("parsed_foods", partial: "ai/parsed_foods", locals: { foods: result }) }
        format.json { render json: result }
      end
    end

    def analyze_progress
      days = params[:days].to_i.positive? ? params[:days].to_i : 30
      logs = current_user.progress_logs.last_30_days

      result = AiService.new(current_user).analyze_progress(logs)

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("progress_analysis", partial: "ai/progress_analysis", locals: { analysis: result }) }
        format.json { render json: result }
      end
    end
  end
end
