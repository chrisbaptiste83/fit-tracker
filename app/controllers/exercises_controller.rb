class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all

    @exercises = @exercises.by_category(params[:category]) if params[:category].present?
    @exercises = @exercises.by_muscle_group(params[:muscle_group]) if params[:muscle_group].present?
    @exercises = @exercises.by_difficulty(params[:difficulty]) if params[:difficulty].present?
    @exercises = @exercises.search(params[:q]) if params[:q].present?

    @exercises = @exercises.order(:name)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @exercise = Exercise.find(params[:id])
  end

  def search
    @exercises = Exercise.search(params[:q]).limit(10)
    render partial: "exercises/search_results", locals: { exercises: @exercises }
  end
end
