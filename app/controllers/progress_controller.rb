class ProgressController < ApplicationController
  before_action :set_progress_log, only: [:show, :edit, :update, :destroy]

  def index
    @progress_logs = current_user.progress_logs.recent.limit(30)
    @latest = @progress_logs.first

    # Chart data
    @weight_data = ProgressLog.weight_trend(current_user, 90)
  end

  def show
  end

  def new
    @progress_log = current_user.progress_logs.build(date: Date.current)
  end

  def create
    @progress_log = current_user.progress_logs.build(progress_log_params)

    if @progress_log.save
      redirect_to progress_index_path, notice: "Progress logged successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @progress_log.update(progress_log_params)
      redirect_to progress_index_path, notice: "Progress updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @progress_log.destroy
    redirect_to progress_index_path, notice: "Progress log deleted."
  end

  def charts
    @weight_data = ProgressLog.weight_trend(current_user, params[:days]&.to_i || 90)
    render partial: "progress/charts"
  end

  private

  def set_progress_log
    @progress_log = current_user.progress_logs.find(params[:id])
  end

  def progress_log_params
    params.require(:progress_log).permit(:date, :weight, :body_fat_percentage, :chest, :waist, :hips, :arms, :thighs, :notes, :photo)
  end
end
