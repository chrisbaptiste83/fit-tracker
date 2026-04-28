# FitTrack AI

A full-stack fitness and nutrition tracking application built with Ruby on Rails 8. FitTrack AI helps users log workouts, track nutrition, plan meals, and monitor body composition progress — enhanced by an AI assistant powered by Claude.

[![Ruby](https://img.shields.io/badge/Ruby-3.4-CC342D?logo=ruby&logoColor=white)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.4-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)](https://postgresql.org)
[![Claude AI](https://img.shields.io/badge/Claude-AI-orange)](https://anthropic.com)

## Features

- **Workout tracking** — Create and schedule workouts, add exercises with sets/reps/weight, and mark sessions complete
- **Exercise library** — Browse exercises filtered by category, muscle group, and difficulty
- **Nutrition logging** — Log meals and foods with automatic macro calculation (calories, protein, carbs, fat)
- **Meal planning** — Build weekly meal plans from a recipe library
- **Progress tracking** — Log weight and body measurements over time with trend charts
- **Goal setting** — Set and track weight, strength, habit, and nutrition goals with progress percentages
- **AI assistant** — Chat with Claude for personalized workout plans, meal suggestions, and progress analysis
- **Dashboard** — At-a-glance summary of today's nutrition, upcoming workouts, active goals, and weekly charts

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.0.4 |
| Language | Ruby 3.4 |
| Database | PostgreSQL 16 |
| Frontend | Turbo, Stimulus, Tailwind CSS, DaisyUI |
| Charts | Chartkick + Groupdate |
| AI | Anthropic Claude API (`anthropic` gem) |
| Auth | Rails 8 built-in authentication (bcrypt + session table) |
| Background Jobs | Solid Queue |
| Cache | Solid Cache |
| Web Server | Puma + Thruster |
| Deployment | Kamal 2 |

## Getting Started

### Prerequisites

- Ruby 3.4+ (use `rbenv` — see `.ruby-version`)
- Node.js 20+ (for Tailwind CSS builds)
- PostgreSQL 14+
- An [Anthropic API key](https://console.anthropic.com) for AI features

### Installation

```bash
git clone git@github.com:chrisbaptiste83/fit-tracker.git
cd fit-tracker
bundle install
```

### Environment Variables

Create a `.env` file (or export in your shell):

```bash
ANTHROPIC_API_KEY=your_api_key_here

# PostgreSQL (only if your local setup requires credentials)
PGUSER=your_pg_user
PGPASSWORD=your_pg_password
PGHOST=localhost

# Production only
DATABASE_URL=postgres://user:password@host/fit_tracker_production
```

| Variable | Required | Description |
|---|---|---|
| `ANTHROPIC_API_KEY` | Yes (for AI) | Anthropic Claude API key |
| `PGUSER` | No | PostgreSQL user (default: `chris`) |
| `PGPASSWORD` | No | PostgreSQL password |
| `PGHOST` | No | PostgreSQL host (default: `localhost`) |
| `DATABASE_URL` | Production | Full PostgreSQL connection URL |

### Database Setup

```bash
bin/rails db:create db:migrate db:seed
```

The seed file populates exercises, sample foods, and a demo user account.

### Running the App

```bash
bin/dev
```

This starts Puma and the Tailwind CSS watcher concurrently via Foreman. Visit `http://localhost:3000`.

## Testing

The suite uses Rails' built-in Minitest with fixtures.

```bash
bin/rails test                                        # full suite
bin/rails test test/models/user_test.rb               # model tests
bin/rails test test/controllers/workouts_controller_test.rb  # controller tests
```

Security scan and linting:

```bash
bin/rails brakeman    # security scan
bin/rails rubocop     # linting
```

## Architecture

### Models

```
User
├── has_many :workouts
│   └── has_many :workout_exercises → belongs_to :exercise
├── has_many :meals
│   └── has_many :meal_foods → belongs_to :food
├── has_many :recipes
├── has_many :meal_plans
│   └── has_many :meal_plan_days (breakfast/lunch/dinner_recipe)
├── has_many :progress_logs
├── has_many :goals
└── has_many :ai_conversations
```

### Key Calculations

| Metric | Formula |
|---|---|
| BMR | Mifflin-St Jeor equation (split by gender) |
| TDEE | BMR × activity multiplier (1.2 – 1.9) |
| BMI | weight (kg) / height (m)² |
| Goal progress | `(current_value / target_value * 100)`, capped at 100% |

### AI Service (`app/services/ai_service.rb`)

`AiService` wraps the Anthropic Claude API and exposes five methods:

| Method | Description |
|---|---|
| `generate_workout(user, preferences)` | Returns a structured JSON workout plan |
| `suggest_meals(user, preferences)` | Meal recommendations based on goals |
| `analyze_progress(user)` | Summarizes weight trend with encouragement |
| `parse_food(description)` | Parses natural-language food entries into structured data |
| `chat(user, message, context)` | Context-aware fitness Q&A |

### Authentication

Rails 8's built-in `Authentication` concern handles session management. Sessions are stored in the `sessions` table and identified via a signed, HTTPOnly cookie. Login is rate-limited to 10 attempts per 3 minutes.

## Deployment

Deployed via [Kamal 2](https://kamal-deploy.org). Review `config/deploy.yml` and set the required secrets before deploying:

```bash
kamal setup    # first deploy — provisions server and starts containers
kamal deploy   # subsequent deploys (zero-downtime)
kamal logs     # tail production logs
kamal console  # open Rails console in production
```
