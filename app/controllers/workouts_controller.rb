class WorkoutsController < ApplicationController
  before_action :set_workout, only: [:show, :edit, :update, :destroy, :complete]

  def index
    @workouts = current_user.workouts.includes(:exercises).order(scheduled_date: :desc)
    @upcoming = @workouts.upcoming
    @past = @workouts.past
  end

  def show
    @workout_exercises = @workout.workout_exercises.includes(:exercise).order(:order)
  end

  def new
    @workout = current_user.workouts.build(scheduled_date: Date.current)
    @exercises = Exercise.all
  end

  def create
    @workout = current_user.workouts.build(workout_params)

    if @workout.save
      redirect_to @workout, notice: "Workout created successfully."
    else
      @exercises = Exercise.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @exercises = Exercise.all
  end

  def update
    if @workout.update(workout_params)
      redirect_to @workout, notice: "Workout updated successfully."
    else
      @exercises = Exercise.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "Workout deleted."
  end

  def complete
    @workout.complete!
    redirect_to @workout, notice: "Workout completed! Great job!"
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name, :scheduled_date, :duration_minutes, :calories_burned, :notes, :ai_generated)
  end
end
