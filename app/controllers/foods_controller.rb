class FoodsController < ApplicationController
  def index
    @foods = Food.order(:name)
    @foods = @foods.search(params[:q]) if params[:q].present?
    @foods = @foods.limit(50)
  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)

    if @food.save
      redirect_to @food, notice: "Food added to database."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @foods = Food.search(params[:q]).limit(10)
    render partial: "foods/search_results", locals: { foods: @foods }
  end

  private

  def food_params
    params.require(:food).permit(:name, :brand, :serving_size, :serving_unit, :calories, :protein, :carbs, :fat, :fiber, :barcode)
  end
end
