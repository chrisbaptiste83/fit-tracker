class ProfileController < ApplicationController
  def show
    @user = current_user
    @stats = {
      total_workouts: @user.workouts.completed.count,
      total_meals_logged: @user.meals.count,
      goals_completed: @user.goals.completed.count,
      days_active: @user.progress_logs.count
    }
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:height, :weight, :age, :gender, :fitness_goal, :activity_level, :daily_calorie_goal, :protein_goal, :carb_goal, :fat_goal)
  end
end
