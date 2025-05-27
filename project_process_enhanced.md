# 🚀 Spotlight OS - Complete Project Development Process

## Table of Contents
1. [Project Overview](#project-overview)
2. [Development Environment Setup](#development-environment-setup)
3. [Core Architecture](#core-architecture)
4. [Database & Models](#database--models)
5. [Backend Development](#backend-development)
6. [Frontend Development](#frontend-development)
7. [API Integration](#api-integration)
8. [Testing Strategy](#testing-strategy)
9. [Deployment Pipeline](#deployment-pipeline)
10. [Monitoring & Analytics](#monitoring--analytics)
11. [Security Implementation](#security-implementation)
12. [Performance Optimization](#performance-optimization)

---

## Project Overview

### Vision Statement
Spotlight OS is a comprehensive voice AI sales platform that enables businesses to create, deploy, and manage AI-powered sales assistants for lead qualification, appointment booking, and customer engagement.

### Core Features
- **AI Assistant Builder**: Drag-and-drop interface for creating custom voice AI assistants
- **Real-time Conversations**: Live conversation management with sentiment analysis
- **Lead Management**: Advanced lead qualification and scoring system
- **Appointment Booking**: Integrated calendar scheduling with external services
- **Analytics Dashboard**: Comprehensive reporting and performance metrics
- **Multi-channel Support**: Phone, web chat, and social media integration

### Technology Stack
- **Backend**: Ruby on Rails 7.1+
- **Frontend**: Hotwire (Turbo + Stimulus) + TailwindCSS
- **Database**: PostgreSQL
- **Cache**: Redis
- **Queue**: Solid Queue
- **Storage**: AWS S3 / CloudFlare R2
- **Deployment**: Docker + Kubernetes / Heroku
- **Monitoring**: New Relic / DataDog

---

## Development Environment Setup

### Prerequisites
```bash
# Required software versions
ruby 3.2.0+
node 18.0+
postgresql 14+
redis 6.0+
git 2.30+
```

### Initial Setup
```bash
# 1. Clone repository
git clone https://github.com/your-org/spotlight_os.git
cd spotlight_os

# 2. Install dependencies
bundle install
npm install

# 3. Environment configuration
cp .env.example .env
# Edit .env with your configuration

# 4. Database setup
rails db:create
rails db:migrate
rails db:seed

# 5. Start development servers
bin/dev  # Starts Rails + CSS/JS build processes
```

### Environment Variables
```bash
# Database
DATABASE_URL=postgresql://localhost/spotlight_os_development

# External APIs
OPENAI_API_KEY=your_openai_key
ELEVENLABS_API_KEY=your_elevenlabs_key
STRIPE_SECRET_KEY=your_stripe_key
CALENDLY_API_KEY=your_calendly_key

# Services
REDIS_URL=redis://localhost:6379
S3_BUCKET=your-s3-bucket

# Security
SECRET_KEY_BASE=your_secret_key
DEVISE_SECRET_KEY=your_devise_key
```

---

## Core Architecture

### System Architecture Diagram
```mermaid
graph TB
    User[User Interface] --> LB[Load Balancer]
    LB --> App1[Rails App Instance 1]
    LB --> App2[Rails App Instance 2]
    
    App1 --> DB[(PostgreSQL)]
    App2 --> DB
    
    App1 --> Redis[(Redis Cache)]
    App2 --> Redis
    
    App1 --> Queue[Solid Queue]
    App2 --> Queue
    
    Queue --> Workers[Background Workers]
    Workers --> AI[AI Services]
    Workers --> External[External APIs]
    
    AI --> OpenAI[OpenAI API]
    AI --> ElevenLabs[ElevenLabs API]
    
    External --> Stripe[Stripe API]
    External --> Calendly[Calendly API]
```

### Service Layer Structure
```
app/
├── services/
│   ├── ai/
│   │   ├── conversation_service.rb
│   │   ├── sentiment_analyzer.rb
│   │   └── voice_synthesizer.rb
│   ├── integrations/
│   │   ├── stripe_service.rb
│   │   ├── calendly_service.rb
│   │   └── webhook_handler.rb
│   └── core/
│       ├── lead_scorer.rb
│       ├── assistant_builder.rb
│       └── analytics_service.rb
```

---

## Database & Models

### Core Models Generation
```bash
# User authentication with Devise
rails g devise:install
rails g devise User name:string company:string role:string plan:string

# Assistant builder with advanced configuration
rails g model Assistant \
  name:string \
  tone:string \
  role:string \
  script:text \
  voice_id:string \
  language:string \
  active:boolean \
  user:references

# Enhanced lead management
rails g model Lead \
  name:string \
  email:string \
  phone:string \
  company:string \
  source:string \
  status:string \
  score:integer \
  qualified:boolean \
  metadata:jsonb \
  assistant:references

# Conversation tracking with analytics
rails g model Conversation \
  lead:references \
  assistant:references \
  source:string \
  status:string \
  score:integer \
  duration:integer \
  started_at:datetime \
  ended_at:datetime

# Detailed transcript analysis
rails g model Transcript \
  conversation:references \
  content:text \
  speaker:string \
  sentiment:string \
  confidence:float \
  timestamp:float

# Appointment scheduling
rails g model Appointment \
  lead:references \
  assistant:references \
  scheduled_at:datetime \
  duration:integer \
  status:string \
  external_id:string \
  external_link:string \
  metadata:jsonb
```

### Database Migrations & Indexes
```ruby
# Add indexes for performance
class AddIndexesToCoreModels < ActiveRecord::Migration[7.1]
  def change
    add_index :leads, [:status, :score]
    add_index :conversations, [:created_at, :status]
    add_index :transcripts, [:conversation_id, :speaker]
    add_index :appointments, [:scheduled_at, :status]
    
    # Full-text search indexes
    add_index :leads, :name, using: :gin
    add_index :transcripts, :content, using: :gin
  end
end
```

---

## Backend Development

### Controllers Structure
```bash
# Generate controllers with proper actions
rails g controller Dashboard index analytics
rails g controller Assistants index show new create edit update destroy
rails g controller Leads index show new create edit update destroy
rails g controller Conversations index show new create
rails g controller Appointments index show new create edit update destroy
rails g controller Api::V1::Base --skip-template-engine
```

### Enhanced Routes Configuration
```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'dashboard#index'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  # Main application routes
  resources :assistants do
    member do
      patch :toggle_active
      get :analytics
    end
    
    resources :leads, except: [:destroy] do
      resources :conversations, only: [:show, :create]
    end
  end
  
  resources :leads do
    member do
      patch :update_status
      get :call_history
    end
  end
  
  resources :conversations do
    resources :transcripts, only: [:index, :show]
    member do
      get :analytics
      patch :update_score
    end
  end
  
  resources :appointments do
    member do
      patch :confirm
      patch :reschedule
      patch :cancel
    end
  end
  
  # Dashboard and analytics
  get '/dashboard', to: 'dashboard#index'
  get '/analytics', to: 'dashboard#analytics'
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :webhooks, only: [:create]
      resources :conversations, only: [:create, :update]
      resources :leads, only: [:create, :update]
    end
  end
  
  # Health check
  get '/health', to: 'health#check'
end
```

### Service Classes Implementation
```ruby
# app/services/ai/conversation_service.rb
class Ai::ConversationService
  def initialize(assistant, lead)
    @assistant = assistant
    @lead = lead
    @openai_client = OpenAI::Client.new
  end
  
  def start_conversation
    conversation = create_conversation
    generate_initial_response(conversation)
  end
  
  def process_response(conversation, user_input)
    # Process user input through AI
    # Generate appropriate response
    # Update conversation state
  end
  
  private
  
  def create_conversation
    Conversation.create!(
      assistant: @assistant,
      lead: @lead,
      source: 'phone',
      status: 'active',
      started_at: Time.current
    )
  end
end
```

---

## Frontend Development

### TailwindCSS Configuration
```bash
# Install and configure TailwindCSS
rails tailwindcss:install

# Install additional UI dependencies
npm install @headlessui/react @heroicons/react alpinejs
```

### Stimulus Controllers
```javascript
// app/javascript/controllers/conversation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input", "status"]
  static values = { 
    conversationId: Number,
    assistantId: Number 
  }
  
  connect() {
    this.initializeWebSocket()
    this.setupAutoScroll()
  }
  
  initializeWebSocket() {
    this.cable = ActionCable.createConsumer()
    this.subscription = this.cable.subscriptions.create(
      { 
        channel: "ConversationChannel", 
        conversation_id: this.conversationIdValue 
      },
      {
        received: (data) => this.handleMessage(data)
      }
    )
  }
  
  sendMessage(event) {
    event.preventDefault()
    const message = this.inputTarget.value.trim()
    
    if (message) {
      this.subscription.send({ message: message })
      this.inputTarget.value = ""
      this.addMessageToChat(message, "user")
    }
  }
  
  handleMessage(data) {
    this.addMessageToChat(data.message, "assistant")
    this.updateStatus(data.status)
  }
}
```

### Component Library
```erb
<!-- app/views/shared/_assistant_card.html.erb -->
<div class="bg-white rounded-lg shadow-md p-6 border border-gray-200 hover:shadow-lg transition-shadow">
  <div class="flex items-center justify-between mb-4">
    <h3 class="text-lg font-semibold text-gray-900"><%= assistant.name %></h3>
    <span class="px-2 py-1 text-xs rounded-full <%= assistant.active? ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800' %>">
      <%= assistant.active? ? 'Active' : 'Inactive' %>
    </span>
  </div>
  
  <p class="text-gray-600 mb-4"><%= assistant.role %></p>
  
  <div class="flex items-center justify-between">
    <div class="text-sm text-gray-500">
      <%= pluralize(assistant.leads.count, 'lead') %> managed
    </div>
    
    <div class="flex space-x-2">
      <%= link_to "Edit", edit_assistant_path(assistant), 
          class: "text-indigo-600 hover:text-indigo-900 text-sm font-medium" %>
      <%= link_to "View", assistant_path(assistant), 
          class: "text-gray-600 hover:text-gray-900 text-sm font-medium" %>
    </div>
  </div>
</div>
```

---

## API Integration

### OpenAI Integration
```ruby
# app/services/ai/openai_service.rb
class Ai::OpenaiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end
  
  def generate_response(context, user_input, assistant_config)
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: build_messages(context, user_input, assistant_config),
        temperature: 0.7,
        max_tokens: 150
      }
    )
    
    response.dig("choices", 0, "message", "content")
  end
  
  private
  
  def build_messages(context, user_input, assistant_config)
    [
      {
        role: "system",
        content: build_system_prompt(assistant_config)
      },
      *context.map { |msg| format_message(msg) },
      {
        role: "user",
        content: user_input
      }
    ]
  end
end
```

### Webhook Handlers
```ruby
# app/controllers/api/v1/webhooks_controller.rb
class Api::V1::WebhooksController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token
  
  def create
    case params[:type]
    when 'stripe.payment_succeeded'
      handle_payment_success
    when 'calendly.appointment_created'
      handle_appointment_created
    when 'elevenlabs.speech_completed'
      handle_speech_completed
    else
      head :ok
    end
  end
  
  private
  
  def handle_payment_success
    # Process successful payment
    # Update user subscription
  end
  
  def handle_appointment_created
    # Sync appointment from Calendly
    # Send confirmation notifications
  end
end
```

---

## Testing Strategy

### Test Environment Setup
```ruby
# Gemfile (test group)
group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
  gem 'selenium-webdriver'
end
```

### Model Tests
```ruby
# spec/models/assistant_spec.rb
RSpec.describe Assistant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:role) }
    it { should belong_to(:user) }
    it { should have_many(:leads) }
  end
  
  describe 'methods' do
    let(:assistant) { create(:assistant) }
    
    it 'calculates average lead score' do
      create(:lead, assistant: assistant, score: 80)
      create(:lead, assistant: assistant, score: 60)
      
      expect(assistant.average_lead_score).to eq(70)
    end
  end
end
```

### Integration Tests
```ruby
# spec/requests/conversations_spec.rb
RSpec.describe 'Conversations API', type: :request do
  let(:user) { create(:user) }
  let(:assistant) { create(:assistant, user: user) }
  let(:lead) { create(:lead, assistant: assistant) }
  
  before { sign_in user }
  
  describe 'POST /api/v1/conversations' do
    let(:params) do
      {
        assistant_id: assistant.id,
        lead_id: lead.id,
        message: 'Hello, I am interested in your product'
      }
    end
    
    it 'creates a new conversation' do
      expect {
        post '/api/v1/conversations', params: params
      }.to change(Conversation, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
  end
end
```

---

## Deployment Pipeline

### Docker Configuration
```dockerfile
# Dockerfile
FROM ruby:3.2.0-alpine

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  nodejs \
  npm \
  git

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
```

### GitHub Actions CI/CD
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.2.0
        bundler-cache: true
    
    - name: Set up Node
      uses: actions/setup-node@v3
      with:
        node-version: 18
        cache: npm
    
    - name: Install dependencies
      run: |
        bundle install
        npm install
    
    - name: Run tests
      env:
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/spotlight_test
      run: |
        bundle exec rails db:create
        bundle exec rails db:migrate
        bundle exec rspec
    
    - name: Build and push Docker image
      if: github.ref == 'refs/heads/main'
      run: |
        docker build -t spotlight-os:latest .
        # Push to registry
```

---

## Monitoring & Analytics

### Application Monitoring
```ruby
# config/initializers/monitoring.rb
if Rails.env.production?
  # New Relic configuration
  require 'newrelic_rpm'
  
  # Custom metrics
  NewRelic::Agent.add_custom_attributes({
    app_version: ENV['APP_VERSION'],
    deployment_id: ENV['DEPLOYMENT_ID']
  })
end
```

### Analytics Dashboard
```ruby
# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def analytics
    @metrics = {
      total_leads: current_user.leads.count,
      qualified_leads: current_user.leads.qualified.count,
      active_conversations: current_user.conversations.active.count,
      conversion_rate: calculate_conversion_rate,
      avg_response_time: calculate_avg_response_time
    }
    
    @charts_data = {
      leads_over_time: leads_over_time_data,
      conversion_funnel: conversion_funnel_data,
      sentiment_distribution: sentiment_distribution_data
    }
  end
end
```

---

## Security Implementation

### Authentication & Authorization
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
  
  private
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :company])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :company])
  end
end
```

### API Security
```ruby
# app/controllers/api/v1/base_controller.rb
class Api::V1::BaseController < ActionController::API
  before_action :authenticate_api_user
  before_action :set_rate_limits
  
  private
  
  def authenticate_api_user
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = User.find_by(api_token: token) if token
    
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
  
  def set_rate_limits
    # Implement rate limiting logic
  end
end
```

---

## Performance Optimization

### Database Optimization
```ruby
# config/initializers/database.rb
ActiveRecord::Base.connection.execute("SET statement_timeout = '30s'")

# Add connection pooling
Rails.application.config.database_configuration[Rails.env]["pool"] = 20
Rails.application.config.database_configuration[Rails.env]["timeout"] = 5000
```

### Caching Strategy
```ruby
# config/environments/production.rb
config.cache_store = :redis_cache_store, {
  url: ENV['REDIS_URL'],
  expires_in: 1.hour,
  namespace: 'spotlight_os'
}

# Enable fragment caching
config.action_controller.perform_caching = true
```

### Background Jobs
```ruby
# app/jobs/conversation_analyzer_job.rb
class ConversationAnalyzerJob < ApplicationJob
  queue_as :default
  
  def perform(conversation_id)
    conversation = Conversation.find(conversation_id)
    
    # Analyze sentiment
    SentimentAnalyzer.new(conversation).analyze
    
    # Update lead score
    LeadScorer.new(conversation.lead).update_score
    
    # Send notifications if needed
    NotificationService.new(conversation).send_updates
  end
end
```

---

## Next Steps & Roadmap

### Phase 1: MVP (Weeks 1-4)
- [ ] Complete core models and controllers
- [ ] Basic dashboard with CRUD operations
- [ ] Simple AI assistant creation
- [ ] Basic conversation tracking
- [ ] User authentication and basic authorization

### Phase 2: Core Features (Weeks 5-8)
- [ ] Real-time conversation interface
- [ ] OpenAI integration for responses
- [ ] Lead scoring algorithm
- [ ] Basic appointment booking
- [ ] Email notifications

### Phase 3: Advanced Features (Weeks 9-12)
- [ ] Voice synthesis with ElevenLabs
- [ ] Advanced analytics dashboard
- [ ] Stripe integration for billing
- [ ] Calendly integration
- [ ] Mobile responsive design

### Phase 4: Scale & Optimize (Weeks 13-16)
- [ ] Performance optimization
- [ ] Advanced security features
- [ ] Multi-tenant architecture
- [ ] API rate limiting
- [ ] Comprehensive testing coverage

### Future Enhancements
- [ ] Multi-language support
- [ ] Advanced AI training capabilities
- [ ] Integration marketplace
- [ ] White-label solutions
- [ ] Enterprise features (SSO, custom branding)

---

## Development Guidelines

### Code Style
- Follow Rails conventions and best practices
- Use Rubocop for Ruby linting
- Use Prettier for JavaScript/CSS formatting
- Write comprehensive tests for all features
- Document complex business logic

### Git Workflow
```bash
# Feature branch workflow
git checkout -b feature/assistant-builder
git commit -m "feat: add assistant builder interface"
git push origin feature/assistant-builder
# Create pull request
```

### Code Review Checklist
- [ ] Tests pass and cover new functionality
- [ ] Code follows style guidelines
- [ ] Security considerations addressed
- [ ] Performance impact evaluated
- [ ] Documentation updated
- [ ] Database migrations are reversible

---

## Resources & Documentation

### External APIs
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [ElevenLabs API Documentation](https://docs.elevenlabs.io/)
- [Stripe API Documentation](https://stripe.com/docs/api)
- [Calendly API Documentation](https://developer.calendly.com/)

### Framework Documentation
- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire Documentation](https://hotwired.dev/)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)

### Development Tools
- [RSpec Documentation](https://rspec.info/)
- [Factory Bot Documentation](https://github.com/thoughtbot/factory_bot)
- [Capybara Documentation](https://github.com/teamcapybara/capybara)

---

*This document is a living guide that should be updated as the project evolves. Regular reviews and updates ensure it remains accurate and useful for the development team.*
