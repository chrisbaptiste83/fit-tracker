class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy, :complete]

  def index
    @active_goals = current_user.goals.active.order(:target_date)
    @completed_goals = current_user.goals.completed.order(completed_at: :desc).limit(10)
  end

  def show
  end

  def new
    @goal = current_user.goals.build(start_date: Date.current, target_date: 30.days.from_now)
  end

  def create
    @goal = current_user.goals.build(goal_params)

    if @goal.save
      redirect_to goals_path, notice: "Goal created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_path, notice: "Goal updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Goal deleted."
  end

  def complete
    @goal.complete!
    redirect_to goals_path, notice: "Congratulations! Goal completed!"
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:goal_type, :target_value, :current_value, :unit, :start_date, :target_date, :description)
  end
end
