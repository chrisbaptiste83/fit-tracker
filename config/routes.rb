Rails.application.routes.draw do
  # Authentication
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [:new, :create]

  # Dashboard
  root "dashboard#index"
  get "dashboard", to: "dashboard#index"

  # Profile
  resource :profile, only: [:show, :edit, :update], controller: :profile

  # Workouts & Exercises
  resources :workouts do
    member do
      patch :complete
    end
    resources :workout_exercises, only: [:create, :update, :destroy]
  end
  resources :exercises, only: [:index, :show] do
    collection do
      get :search
    end
  end

  # Nutrition
  get "nutrition", to: "nutrition#index"
  resources :meals do
    resources :meal_foods, only: [:create, :update, :destroy]
  end
  resources :foods, only: [:index, :show, :new, :create] do
    collection do
      get :search
    end
  end

  # Recipes & Meal Plans
  resources :recipes do
    collection do
      get :search
    end
  end
  resources :meal_plans do
    resources :meal_plan_days, only: [:update]
  end

  # Progress & Goals
  resources :progress_logs, path: "progress", as: :progress, controller: :progress do
    collection do
      get :charts
    end
  end
  resources :goals do
    member do
      patch :complete
    end
  end

  # AI Features
  namespace :ai do
    get "/", to: "assistant#index"
    post "chat", to: "assistant#chat"
    post "generate_workout", to: "assistant#generate_workout"
    post "suggest_meals", to: "assistant#suggest_meals"
    post "parse_food", to: "assistant#parse_food"
    post "analyze_progress", to: "assistant#analyze_progress"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
