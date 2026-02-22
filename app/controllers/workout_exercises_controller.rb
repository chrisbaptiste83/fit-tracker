class WorkoutExercisesController < ApplicationController
  before_action :set_workout
  before_action :set_workout_exercise, only: [:update, :destroy]

  def create
    @workout_exercise = @workout.workout_exercises.build(workout_exercise_params)

    respond_to do |format|
      if @workout_exercise.save
        format.turbo_stream
        format.html { redirect_to @workout, notice: "Exercise added." }
      else
        format.html { redirect_to @workout, alert: "Could not add exercise." }
      end
    end
  end

  def update
    respond_to do |format|
      if @workout_exercise.update(workout_exercise_params)
        format.turbo_stream
        format.html { redirect_to @workout, notice: "Exercise updated." }
      else
        format.html { redirect_to @workout, alert: "Could not update exercise." }
      end
    end
  end

  def destroy
    @workout_exercise.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@workout_exercise) }
      format.html { redirect_to @workout, notice: "Exercise removed." }
    end
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:workout_id])
  end

  def set_workout_exercise
    @workout_exercise = @workout.workout_exercises.find(params[:id])
  end

  def workout_exercise_params
    params.require(:workout_exercise).permit(:exercise_id, :sets, :reps, :weight, :duration_seconds, :rest_seconds, :order)
  end
end
