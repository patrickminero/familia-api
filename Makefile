.PHONY: help setup up down restart logs logs-web logs-db console bash test db-migrate db-rollback db-reset db-seed clean build rebuild

help:
	@echo "Familia API - Development Commands"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make setup          - Initial setup (build containers + create database)"
	@echo "  make build          - Build Docker images"
	@echo "  make rebuild        - Rebuild Docker images from scratch (no cache)"
	@echo ""
	@echo "Service Management:"
	@echo "  make up             - Start all services in detached mode"
	@echo "  make down           - Stop and remove all containers"
	@echo "  make restart        - Restart all services"
	@echo "  make clean          - Stop containers and remove volumes"
	@echo ""
	@echo "Logs & Monitoring:"
	@echo "  make logs           - View logs from all services"
	@echo "  make logs-web       - View logs from web service only"
	@echo "  make logs-db        - View logs from database service only"
	@echo ""
	@echo "Interactive Access:"
	@echo "  make console        - Open Rails console"
	@echo "  make bash           - Access web container shell"
	@echo "  make db-console     - Access PostgreSQL console"
	@echo ""
	@echo "Database Operations:"
	@echo "  make db-create      - Create database"
	@echo "  make db-migrate     - Run pending migrations"
	@echo "  make db-rollback    - Rollback last migration"
	@echo "  make db-reset       - Drop, create, and migrate database"
	@echo "  make db-seed        - Seed database with sample data"
	@echo "  make db-setup       - Create database and run migrations"
	@echo ""
	@echo "Testing:"
	@echo "  make test           - Run full test suite"
	@echo "  make test-fast      - Run tests without coverage"
	@echo "  make test-models    - Run model tests only"
	@echo "  make test-requests  - Run request tests only"
	@echo "  make wip            - Run tests tagged with :wip only"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint           - Run linter (if configured)"
	@echo "  make bundle         - Install/update gems"
	@echo "  make bundle-update  - Update all gems"
	@echo ""
	@echo "Utilities:"
	@echo "  make routes         - Display all routes"
	@echo "  make ps             - Show running containers"
	@echo "  make stats          - Show container resource usage"

setup: build db-create db-migrate
	@echo "✅ Setup complete! Run 'make up' to start the server."

build:
	@echo "🔨 Building Docker images..."
	docker-compose build

rebuild:
	@echo "🔨 Rebuilding Docker images from scratch..."
	docker-compose build --no-cache

up:
	@echo "🚀 Starting services..."
	docker-compose up web db
	@echo "✅ Services started! API available at http://localhost:3000"

down:
	@echo "⏹️  Stopping services..."
	docker-compose down

restart: down up
	@echo "♻️  Services restarted!"

clean:
	@echo "🧹 Cleaning up containers and volumes..."
	docker-compose down -v
	@echo "✅ Cleanup complete!"

logs:
	docker-compose logs -f

logs-web:
	docker-compose logs -f web

logs-db:
	docker-compose logs -f db

console:
	@echo "🎮 Opening Rails console..."
	docker-compose exec web bundle exec rails console

bash:
	@echo "💻 Accessing web container shell..."
	docker-compose exec web bash

db-console:
	@echo "🗄️  Accessing PostgreSQL console..."
	docker-compose exec db psql -U postgres -d familia_api_development

db-create:
	@echo "📊 Creating database..."
	docker-compose exec web bundle exec rails db:create

db-migrate:
	@echo "🔄 Running migrations..."
	docker-compose exec web bundle exec rails db:migrate

db-rollback:
	@echo "⏪ Rolling back last migration..."
	docker-compose exec web bundle exec rails db:rollback

db-reset:
	@echo "🔄 Resetting database..."
	docker-compose exec web bundle exec rails db:drop db:create db:migrate
	@echo "✅ Database reset complete!"

db-seed:
	@echo "🌱 Seeding database..."
	docker-compose exec web bundle exec rails db:seed

db-setup:
	@echo "📊 Setting up database..."
	docker-compose exec web bundle exec rails db:setup

test:
	@echo "🧪 Running test suite..."
	docker-compose run --rm test

test-fast:
	@echo "🧪 Running tests (fast mode)..."
	docker-compose run --rm test bundle exec rspec --format progress

test-models:
	@echo "🧪 Running model tests..."
	docker-compose run --rm test bundle exec rspec spec/models

test-requests:
	@echo "🧪 Running request tests..."
	docker-compose run --rm test bundle exec rspec spec/requests

test-docker-prepare:
	@echo "🧪 Preparing test database in Docker..."
	docker-compose run --rm test bundle exec rails db:test:prepare

test-docker-rspec:
	@echo "🧪 Running rspec in Docker test service..."
	docker-compose run --rm test bundle exec rspec

wip:
	@echo "🧪 Running WIP tests only..."
	docker-compose run --rm test bundle exec rspec --tag wip

lint:
	@echo "🔍 Running linter..."
	docker-compose exec web bundle exec rubocop

bundle:
	@echo "📦 Installing gems..."
	docker-compose exec web bundle install

bundle-update:
	@echo "📦 Updating gems..."
	docker-compose exec web bundle update

routes:
	@echo "🗺️  Displaying routes..."
	docker-compose exec web bundle exec rails routes

ps:
	@echo "📊 Container status:"
	docker-compose ps

stats:
	@echo "📊 Container resource usage:"
	docker stats --no-stream
