# Familia API

A Rails 7 API-only application for family household management with a focus on medical record tracking.

## Overview

Familia API provides a secure, scalable backend for managing family households and medical records. Built with modern Rails best practices, it features JWT authentication, role-based authorization, and encrypted sensitive data storage.

### Key Features

- 🔐 **JWT Authentication** with Devise and devise-jwt
- 🛡️ **Authorization** using Pundit policies
- 🔒 **Encrypted Medical Records** using Rails 7 native encryption
- ☁️ **Cloud File Storage** with Cloudinary integration
- 🐳 **Dockerized Development** for consistent environments
- ✅ **Comprehensive Testing** with RSpec, FactoryBot, and Shoulda Matchers
- 🚦 **Rate Limiting** with Rack::Attack

## Tech Stack

- **Ruby**: 3.1.2
- **Rails**: 7.1.6 (API-only)
- **Database**: PostgreSQL 14
- **Authentication**: Devise + Devise-JWT
- **Authorization**: Pundit
- **File Storage**: Cloudinary
- **Serialization**: jsonapi-serializer
- **Testing**: RSpec, FactoryBot, Faker, Shoulda Matchers

## Prerequisites

### Option 1: Docker (Recommended)

- Docker Desktop
- Docker Compose

### Option 2: Local Development

- Ruby 3.1.2
- PostgreSQL 14
- Bundler 2.3.26

## Getting Started

### Using Docker (Recommended)

1. **Clone the repository**

   ```bash
   git clone https://github.com/patrickminero/familia-api.git
   cd familia-api
   ```

2. **Set up environment variables**

   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Build and start containers**

   ```bash
   make setup
   # or
   docker-compose up --build
   ```

4. **Verify installation**
   ```bash
   curl http://localhost:3000/up
   ```

The API will be available at `http://localhost:3000`

### Local Development (Without Docker)

1. **Install dependencies**

   ```bash
   bundle install
   ```

2. **Set up environment variables**

   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Create and migrate database**

   ```bash
   rails db:create db:migrate
   ```

4. **Start the server**
   ```bash
   rails server
   ```

## Development Commands

Use the provided Makefile for common tasks:

```bash
make help          # Show all available commands
make setup         # Initial setup (build + database)
make up            # Start all services
make down          # Stop all services
make restart       # Restart all services
make logs          # View logs
make console       # Open Rails console
make bash          # Access container shell
make test          # Run test suite
make db-migrate    # Run migrations
make db-reset      # Reset database
```

## Environment Variables

Required environment variables (see `.env.example`):

```env
# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001

# Email Configuration
DEVISE_MAILER_SENDER=noreply@familiaapi.com

# JWT Secret (generate with: rails secret)
DEVISE_JWT_SECRET_KEY=your_secret_key_here

# Cloudinary Configuration
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Database (Docker only)
DATABASE_HOST=db
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=familia_api_development
```

## API Response Format

All API endpoints return JSON in this standardized format:

```json
{
  "data": { ... },
  "message": "Success message",
  "errors": []
}
```

## Code Style & Conventions

This project follows specific architectural patterns:

- **Service Objects** for complex business logic (`app/services/`)
- **Query Objects** for reusable scopes (`app/queries/`)
- **Pundit Policies** for authorization (`app/policies/`)
- **jsonapi-serializer** for all API responses
- **Strong Parameters** in all controllers
- **N+1 Query Prevention** with `.includes`

See `.github/copilot-instructions.md` for detailed guidelines.

## Testing

Run the test suite:

```bash
# All tests
make test
# or
bundle exec rspec

# Specific file
bundle exec rspec spec/models/user_spec.rb

# With coverage
COVERAGE=true bundle exec rspec
```

## Database Schema

Current models:

- **User**: Authentication and user management with JWT tokens
- **JwtDenylist**: Revoked JWT tokens

(Additional models for households and medical records coming soon)

## Deployment

### Production Dockerfile

The production `Dockerfile` is configured for AMD64 platforms (AWS, GCP, Azure, Railway, Render, Fly.io).

Build for production:

```bash
docker build -t familia-api:latest .
```

### Environment Setup

Ensure all required environment variables are set in your production environment, including:

- `RAILS_MASTER_KEY` or `config/credentials/production.key`
- Database credentials
- Cloudinary credentials
- JWT secret key

## Security

- All sensitive fields are encrypted at rest
- JWT tokens expire after 30 days
- Rate limiting prevents abuse
- Authorization checks on all endpoints
- CORS configured for allowed origins only
- No sensitive data in serializers

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is private and proprietary.

## Support

For questions or issues, please open an issue on GitHub.
