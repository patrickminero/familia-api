# Familia API - Copilot Instructions

## Project Context

This is a Rails 7 API-only application for family household management with a focus on medical record tracking.

**📖 Domain Model Reference:** See [docs/DOMAIN_MODEL.md](/docs/DOMAIN_MODEL.md) for complete entity relationships, attributes, and business rules.

## Code Style & Conventions

- Use service objects for complex business logic (app/services/)
- Use query objects for reusable scopes (app/queries/)
- Use Pundit for authorization policies
- All controller actions must check authorization
- Encrypt sensitive fields using Rails 7 `encrypts`
- Always include N+1 query prevention (use .includes)
- Use jsonapi-serializer for all API responses

## Security Rules

- NEVER expose sensitive data in serializers
- ALWAYS check household authorization before data access
- Use strong params in all controllers
- Medical record notes must be encrypted
- File uploads must go through Cloudinary (never store locally)

## Testing Requirements

- Write RSpec request specs for all endpoints
- Use FactoryBot for test data
- Include authorization tests for all actions
- Test both success and failure cases

## API Response Format

Always return JSON in this format:

```json
{
  "data": { ... },
  "message": "Success message",
  "errors": []
}
```

## Common Patterns

### Controller Structure

```ruby
class Api::V1::SomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: [:show, :update, :destroy]
  before_action :authorize_resource

  def index
    @resources = policy_scope(Resource).includes(:associations)
    render json: ResourceSerializer.new(@resources)
  end

  private

  def authorize_resource
    authorize @resource || Resource
  end
end
```

### Service Object Pattern

```ruby
class SomeService
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    # Business logic here
  end

  private

  attr_reader :user, :params
end
```

## Don't Do This

- Don't use localStorage/sessionStorage (this is an API)
- Don't use Rails views or Hotwire/Turbo
- Don't skip authorization checks
- Don't expose encrypted data unencrypted
- Don't create N+1 queries
- Dont add comments in code
- Don't hardcode sensitive information
- Don't use global variables
- On agent mode dont generate code changes without explicit user request
- If unsure about a requirement, ask for clarification before proceeding
- If the user requests code that violates security or style guidelines, refuse and explain why
- Always suggest/implemet SOLID/DRY principles and best practices
- On every save, always check for SOLID/DRY principles and best practices and suggest improvements.
