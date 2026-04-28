# FitTrack AI

A full-stack fitness and nutrition tracking application built with Ruby on Rails 8, featuring an AI-powered assistant backed by Anthropic's Claude API. Track workouts, log meals, monitor progress, set goals, and get personalized recommendations — all in one place.

[![Ruby](https://img.shields.io/badge/Ruby-3.4.2-CC342D?logo=ruby&logoColor=white)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.4-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)](https://postgresql.org)
[![Claude AI](https://img.shields.io/badge/Claude-AI-orange)](https://anthropic.com)

**Live:** [fit-track.space](https://fit-track.space)

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture Overview](#architecture-overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Local Setup](#local-setup)
- [Running Tests](#running-tests)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [AI Integration](#ai-integration)
- [Database Schema](#database-schema)
- [Contributing](#contributing)

---

## Features

### Workout Management
- Create, schedule, and complete workouts
- Browse an exercise library organized by category, muscle group, and difficulty
- Log sets, reps, weight, and duration per exercise
- View upcoming and past workout history

### Nutrition Tracking
- Log meals (breakfast, lunch, dinner, snack) with full macro breakdown
- Food database with calories, protein, carbohydrates, fat, and fiber per serving
- Daily nutrition dashboard with progress toward calorie and macro goals
- Recipe management with per-serving nutritional data

### Meal Planning
- Weekly meal plan builder linking recipes to each day of the week
- AI-generated weekly meal plans based on user calorie goals and preferences

### Progress & Goals
- Log body metrics over time: weight, body fat, and key measurements
- Upload progress photos (via Active Storage)
- Visual weight-trend charts powered by Chartkick
- Goal tracker with types: weight, strength, habit, and nutrition
- Goal progress percentage, days remaining, and on-track status

### AI Assistant (Claude-powered)
- **Workout Generator**: Produces a complete structured workout (with exercises, sets, reps, rest) based on duration, focus, equipment, and difficulty
- **Meal Suggester**: Recommends meals calibrated to remaining daily calories and meal type
- **Progress Analyzer**: Summarizes weight trend over the past 30 days with personalized insights
- **Food Parser**: Parses natural-language food logs ("two eggs and a banana") into structured nutrition data
- **Free-form Chat**: Context-aware fitness and nutrition coaching conversation

### User Profiles
- BMR calculation (Mifflin-St Jeor equation) and TDEE based on activity level
- Per-user calorie, protein, carb, and fat daily targets
- Fitness goal and activity level preferences

### Authentication
- Custom session-based authentication — no third-party auth dependencies
- Signed `httponly` session cookies
- Rate-limited login (10 attempts / 3 minutes)
- Password reset via email token

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.4.2 |
| Framework | Rails 8.0.4 |
| Database | PostgreSQL 16 |
| Asset Pipeline | Propshaft |
| CSS | Tailwind CSS + DaisyUI 4 |
| JavaScript | Importmap + Hotwire (Turbo + Stimulus) |
| Authentication | Custom `has_secure_password` sessions |
| AI | Anthropic Claude (`claude-sonnet-4-20250514`) |
| Charts | Chartkick + Groupdate |
| Background Jobs | Solid Queue |
| Caching | Solid Cache |
| WebSockets | Solid Cable |
| Web Server | Puma + Thruster |
| Deployment | Kamal 2 + Docker |
| CI/CD | GitHub Actions |
| Security Scan | Brakeman + RuboCop |
| Testing | Rails MiniTest + Capybara + Selenium |

---

## Architecture Overview

FitTrack AI is a Rails 8 monolith following a conventional MVC structure with a service layer for external API calls.

```
┌─────────────────────────────────────────────────────────┐
│                      Browser / PWA                       │
│              (Turbo Drive + Turbo Streams)               │
└──────────────────────────┬──────────────────────────────┘
                           │  HTTP / WebSocket
┌──────────────────────────▼──────────────────────────────┐
│            Thruster (HTTP cache + compression)           │
│                    Puma (web server)                     │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│                   Rails 8 Application                    │
│                                                          │
│  Controllers ──► Views (ERB + Tailwind CSS + DaisyUI)   │
│       │                                                  │
│     Models ──────────────────────► PostgreSQL 16         │
│       │           (primary, cache, queue, cable)         │
│       │                                                  │
│  AiService ──────────────────────► Anthropic Claude API  │
│                                    (claude-sonnet-4)     │
│                                                          │
│  Solid Queue (background jobs)                           │
│  Active Storage (progress photos)                        │
└─────────────────────────────────────────────────────────┘
```

**Key design decisions:**
- **PostgreSQL for all environments** — Primary database, job queue, cache, and ActionCable backend; consistent behavior across dev, test, and production
- **No JavaScript bundler** — importmaps keep the frontend lean; no Node.js build step
- **Custom auth** — hand-rolled session authentication using Rails 8's `authenticate_by` instead of Devise, keeping the implementation transparent and minimal

---

## Getting Started

### Prerequisites

- Ruby 3.4.2 (`rbenv` or `asdf` recommended — see `.ruby-version`)
- Bundler 2.x
- PostgreSQL 14+
- An [Anthropic API key](https://console.anthropic.com/) for AI features

### Local Setup

```bash
git clone https://github.com/chrisbaptiste83/fit-tracker.git
cd fit-tracker

bundle install

bin/rails db:create db:migrate db:seed

# Add your Anthropic API key to Rails credentials
bin/rails credentials:edit
# anthropic_api_key: sk-ant-...

bin/dev
```

The application will be available at `http://localhost:3000`.

`bin/dev` starts Rails via Foreman using `Procfile.dev`, running both the Rails server and the Tailwind CSS watcher in parallel.

**Seed data** creates four realistic user accounts for development:

| Email | Password | Goal |
|---|---|---|
| `alex@fittrack.com` | `password123` | Build Muscle |
| `sarah@fittrack.com` | `password123` | Lose Weight |
| `marcus@fittrack.com` | `password123` | Endurance |
| `jordan@fittrack.com` | `password123` | Maintain |

---

## Running Tests

```bash
bin/rails db:test:prepare   # prepare the test database
bin/rails test              # all tests
bin/rails test test/models  # model tests only
bin/rails test test/controllers  # controller tests only
bin/rails test:system       # system tests (requires Chrome)

# Full CI suite
bin/rails test && bundle exec brakeman --no-pager && bundle exec rubocop
```

The suite uses **Rails MiniTest** with **fixtures**. Controller tests assert authentication enforcement, authorization boundaries, correct redirects, and HTTP status codes. Model tests cover validations, enums, scopes, and business logic methods.

---

## Environment Variables

| Variable | Description | Required |
|---|---|---|
| `RAILS_MASTER_KEY` | Rails credentials decryption key | Yes (production) |
| `ANTHROPIC_API_KEY` | Anthropic API key for Claude | Yes (AI features) |
| `PGUSER` | PostgreSQL user | No (default: `chris`) |
| `PGPASSWORD` | PostgreSQL password | No |
| `PGHOST` | PostgreSQL host | No (default: `localhost`) |
| `DATABASE_URL` | Full PostgreSQL connection URL | Production |

In production, secrets are injected via Kamal from `.kamal/secrets`. In development, store `ANTHROPIC_API_KEY` in `config/credentials.yml.enc`:

```bash
bin/rails credentials:edit
# anthropic_api_key: sk-ant-...
```

---

## Deployment

Deployed via **Kamal 2** to a single Docker host with an Nginx SSL proxy managed by Let's Encrypt.

```bash
kamal setup     # first-time server provisioning
kamal deploy    # deploy a new version (zero-downtime)
kamal app logs  # view application logs
kamal console   # open Rails console on the server
```

**Infrastructure:**

| Component | Detail |
|---|---|
| Server | `172.236.243.75` |
| Domain | `fit-track.space` (SSL via Let's Encrypt) |
| Docker image | `chrisbaptiste83/fit_tracker` (Docker Hub) |
| Persistent volume | `fit_tracker_storage:/rails/storage` |
| Architecture | `linux/amd64` |

### CI/CD Pipeline

Every push to `main` and every pull request runs four parallel GitHub Actions jobs:

| Job | Tool | Description |
|---|---|---|
| `scan_ruby` | Brakeman | Static security analysis |
| `scan_js` | importmap audit | JavaScript dependency audit |
| `lint` | RuboCop | Code style enforcement |
| `test` | MiniTest + Capybara | Unit, integration, and system tests |

---

## Project Structure

```
fit-tracker/
├── app/
│   ├── controllers/
│   │   ├── ai/assistant_controller.rb    # AI feature endpoints
│   │   ├── concerns/authentication.rb    # Session cookie auth
│   │   ├── dashboard_controller.rb
│   │   ├── exercises_controller.rb
│   │   ├── foods_controller.rb
│   │   ├── goals_controller.rb
│   │   ├── meals_controller.rb
│   │   ├── meal_plans_controller.rb
│   │   ├── nutrition_controller.rb
│   │   ├── profile_controller.rb
│   │   ├── progress_controller.rb
│   │   ├── recipes_controller.rb
│   │   ├── registrations_controller.rb
│   │   ├── sessions_controller.rb
│   │   └── workouts_controller.rb
│   ├── models/
│   │   ├── ai_conversation.rb
│   │   ├── exercise.rb
│   │   ├── food.rb
│   │   ├── goal.rb
│   │   ├── meal.rb
│   │   ├── meal_food.rb
│   │   ├── meal_plan.rb
│   │   ├── meal_plan_day.rb
│   │   ├── progress_log.rb
│   │   ├── recipe.rb
│   │   ├── user.rb
│   │   ├── workout.rb
│   │   └── workout_exercise.rb
│   ├── services/
│   │   └── ai_service.rb               # Anthropic API wrapper
│   └── views/
│       ├── ai/
│       ├── dashboard/
│       ├── exercises/  foods/  meals/
│       ├── meal_plans/  nutrition/
│       ├── progress/  goals/  recipes/
│       ├── workouts/
│       └── layouts/
├── config/
│   ├── routes.rb
│   ├── deploy.yml                      # Kamal configuration
│   └── database.yml
├── db/
│   ├── schema.rb
│   ├── seeds.rb
│   └── migrate/
├── test/
│   ├── controllers/
│   ├── models/
│   ├── system/
│   └── fixtures/
├── Dockerfile
├── Gemfile
├── Procfile.dev
└── .github/workflows/ci.yml
```

---

## AI Integration

All Claude API calls are centralized in `app/services/ai_service.rb`. The service is instantiated with the current user to provide personalized context (weight, height, fitness goal, activity level, daily targets).

```ruby
service = AiService.new(current_user)

workout_data = service.generate_workout(
  duration: 45, focus: "upper body",
  equipment: "dumbbells", difficulty: "intermediate"
)

meal_suggestions = service.suggest_meals(
  remaining_calories: 600, meal_type: "dinner"
)

nutrition = service.parse_food_log("two scrambled eggs and a banana")
```

Conversations are persisted in the `ai_conversations` table as a JSON messages array, enabling continuity across sessions.

| Method | Input | Output |
|---|---|---|
| `generate_workout` | Duration, focus, equipment, difficulty | JSON workout with exercises, sets, reps |
| `suggest_meals` | Remaining calories, meal type, preferences | 3 JSON meal suggestions with macros |
| `analyze_progress` | Last 30 days of weight logs | Text analysis with recommendations |
| `chat` | Message + context (workout/nutrition/general) | Conversational text response |
| `parse_food_log` | Natural-language food description | JSON with name, quantity, unit, macros |

---

## Database Schema

The application uses 13 tables across three domains:

```
users ──┬── workouts ── workout_exercises ── exercises
        ├── meals ──── meal_foods ────────── foods
        ├── recipes ── meal_plan_days ─┐
        ├── meal_plans ───────────────┘
        ├── progress_logs
        ├── goals
        ├── ai_conversations
        └── sessions
```

Key relationships:
- A **User** has many workouts, meals, recipes, meal plans, progress logs, goals, and AI conversations
- A **Workout** has many workout_exercises (ordered), each linking to an exercise with sets/reps/weight/duration
- A **Meal** has many meal_foods linking foods with a `servings` decimal multiplier
- A **MealPlan** spans one week; each **MealPlanDay** references breakfast, lunch, and dinner recipes by FK
- A **ProgressLog** is unique per user per date and supports an attached photo via Active Storage

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Write tests for your changes
4. Ensure all tests and linters pass: `bin/rails test && bundle exec rubocop`
5. Open a pull request against `main`

All pull requests run the full CI pipeline automatically.
