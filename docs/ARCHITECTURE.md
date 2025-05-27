# Architecture Documentation

## Overview

Spotlight OS is a modern Ruby on Rails application built with a focus on real-time communication, AI integration, and scalable architecture. The application follows Rails conventions while incorporating modern patterns for SaaS platforms.

## System Architecture

### High-Level Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Application   │    │   External      │
│   (Browser)     │    │   Server        │    │   Services      │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Hotwire       │◄──►│ • Rails 7.1+    │◄──►│ • OpenAI API    │
│ • Stimulus      │    │ • ActionCable   │    │ • ElevenLabs    │
│ • TailwindCSS   │    │ • Solid Queue   │    │ • Stripe        │
│ • WebSockets    │    │ • PostgreSQL    │    │ • Calendly      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Core Components

#### 1. Authentication & Authorization
- **Devise**: User authentication with roles (admin, manager, sales_rep)
- **Role-based Access Control**: Method-level authorization
- **Session Management**: Secure session handling with Rails defaults

#### 2. Real-time Communication
- **ActionCable**: WebSocket connections for live updates
- **Turbo Streams**: Server-side rendering with real-time updates
- **Stimulus Controllers**: Client-side interactions

#### 3. Background Processing
- **Solid Queue**: Background job processing
- **Job Types**:
  - AI API calls (OpenAI, ElevenLabs)
  - Email notifications
  - Data synchronization
  - Report generation

#### 4. Data Layer
- **PostgreSQL**: Primary database
- **ActiveRecord**: ORM with optimized queries
- **Database Schemas**: Separate schemas for different concerns

## Domain Models

### Core Entities

```ruby
# User Management
User
├── has_many :assistants
├── has_many :leads, through: :assistants
└── belongs_to :company (optional)

# AI Assistant Configuration
Assistant
├── belongs_to :user
├── has_many :leads
├── has_many :conversations, through: :leads
└── has_one_attached :voice_sample

# Lead Management
Lead
├── belongs_to :assistant
├── has_many :conversations
├── has_many :appointments
└── has_many :transcripts, through: :conversations

# Conversation Tracking
Conversation
├── belongs_to :lead
├── belongs_to :assistant
├── has_many :transcripts
└── has_one_attached :audio_file

# Data Analysis
Transcript
├── belongs_to :conversation
├── has_rich_text :content
└── jsonb :sentiment_data
```

### Database Schema Design

#### Key Design Decisions

1. **JSONB Columns**: Used for flexible data storage (sentiment analysis, metadata)
2. **UUID Primary Keys**: For distributed systems and security
3. **Soft Deletes**: Maintain data integrity for audit trails
4. **Indexed Columns**: Optimized for common query patterns

#### Performance Optimizations

- **Partial Indexes**: On status columns for active records
- **Composite Indexes**: For multi-column queries
- **Full-text Search**: PostgreSQL's built-in search capabilities
- **Connection Pooling**: Optimized database connection management

## Service Layer Architecture

### Service Objects Pattern

```ruby
# app/services/
├── ai_services/
│   ├── assistant_trainer_service.rb
│   ├── conversation_analyzer_service.rb
│   └── voice_synthesizer_service.rb
├── lead_services/
│   ├── qualification_service.rb
│   ├── scoring_service.rb
│   └── notification_service.rb
└── integration_services/
    ├── calendar_service.rb
    ├── crm_service.rb
    └── payment_service.rb
```

### Service Responsibilities

1. **AI Services**: Handle external AI API interactions
2. **Lead Services**: Business logic for lead management
3. **Integration Services**: Third-party service integrations
4. **Notification Services**: Multi-channel notifications

## Frontend Architecture

### Hotwire Integration

```javascript
// app/javascript/controllers/
├── application.js          // Stimulus application setup
├── conversation_controller.js  // Real-time conversation updates
├── kanban_controller.js    // Drag-and-drop lead board
├── assistant_controller.js // AI assistant configuration
└── chat_controller.js      // Real-time chat interface
```

### Component Structure

1. **Turbo Frames**: Partial page updates without full reload
2. **Turbo Streams**: Real-time DOM updates via WebSocket
3. **Stimulus Controllers**: Enhanced interactivity
4. **CSS Components**: TailwindCSS utility classes

### State Management

- **Hotwire**: Server-side state management
- **Stimulus Values**: Client-side component state
- **ActionCable**: Real-time state synchronization
- **Local Storage**: User preferences and temporary data

## Security Architecture

### Authentication Flow

```
1. User Login → Devise Authentication
2. Session Creation → Secure Cookie
3. Role Assignment → Database Lookup
4. Authorization Check → Method-level Guards
```

### Security Measures

1. **CSRF Protection**: Rails built-in CSRF tokens
2. **SQL Injection Prevention**: Parameterized queries via ActiveRecord
3. **XSS Protection**: Content Security Policy headers
4. **Rate Limiting**: Rack::Attack for API endpoints
5. **Data Encryption**: Encrypted credentials and sensitive data
6. **Audit Logging**: Track user actions and data changes

## Integration Architecture

### External Service Integration

#### AI Services
- **OpenAI API**: GPT models for conversation analysis
- **ElevenLabs**: Voice synthesis for AI assistants
- **Whisper**: Speech-to-text transcription

#### Business Services
- **Stripe**: Payment processing and subscription management
- **Calendly**: Appointment scheduling integration
- **Twilio**: SMS and voice call capabilities

#### Data Flow

```
External API → Service Object → Background Job → Database Update → Real-time Update
```

## Deployment Architecture

### Infrastructure Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Balancer │    │   Application   │    │   Database      │
│   (nginx)       │◄──►│   Servers       │◄──►│   (PostgreSQL)  │
│                 │    │   (Rails)       │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CDN           │    │   Background    │    │   Redis         │
│   (Static       │    │   Jobs          │    │   (ActionCable) │
│   Assets)       │    │   (Solid Queue) │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Deployment Strategy

1. **Kamal Deployment**: Zero-downtime deployments
2. **Docker Containers**: Consistent environment across stages
3. **Health Checks**: Application and database monitoring
4. **Blue-Green Deployment**: Risk mitigation for releases

## Performance Considerations

### Optimization Strategies

1. **Database Optimization**
   - Query optimization with includes/joins
   - Database indexing strategy
   - Connection pooling
   - Read replicas for reporting

2. **Caching Strategy**
   - Fragment caching for expensive operations
   - HTTP caching for static content
   - Redis for session storage
   - CDN for asset delivery

3. **Background Processing**
   - Async job processing for heavy operations
   - Job prioritization and retry logic
   - Queue monitoring and alerting

4. **Frontend Performance**
   - Lazy loading for large datasets
   - Optimized asset pipeline
   - Minimal JavaScript bundle size
   - Progressive enhancement

## Monitoring & Observability

### Logging Strategy

```ruby
# Structured logging with semantic information
Rails.logger.info({
  event: 'conversation_started',
  user_id: user.id,
  assistant_id: assistant.id,
  duration: duration_ms
})
```

### Metrics Collection

1. **Application Metrics**: Response times, error rates, throughput
2. **Business Metrics**: Conversion rates, user engagement, revenue
3. **Infrastructure Metrics**: CPU, memory, disk usage
4. **Custom Metrics**: AI API usage, conversation quality scores

### Error Handling

1. **Exception Tracking**: Centralized error reporting
2. **Graceful Degradation**: Fallback mechanisms for service failures
3. **Circuit Breakers**: Prevent cascade failures
4. **Health Endpoints**: Service availability monitoring

## Development Practices

### Code Organization

1. **Domain-Driven Design**: Organize code by business domains
2. **Service Objects**: Extract complex business logic
3. **Value Objects**: Immutable data structures
4. **Factory Pattern**: Consistent object creation

### Testing Strategy

1. **Unit Tests**: Model and service layer testing
2. **Integration Tests**: Controller and service integration
3. **System Tests**: End-to-end user workflows
4. **Performance Tests**: Load and stress testing

### Code Quality

1. **RuboCop**: Ruby style guide enforcement
2. **Brakeman**: Security vulnerability scanning
3. **Code Coverage**: Minimum coverage requirements
4. **Code Review**: Peer review process

## Scalability Considerations

### Horizontal Scaling

1. **Stateless Application**: No server-side session storage
2. **Database Sharding**: Partition data across multiple databases
3. **Microservices**: Break down monolith for independent scaling
4. **API Gateway**: Centralized request routing and rate limiting

### Vertical Scaling

1. **Resource Optimization**: CPU and memory profiling
2. **Database Tuning**: Query optimization and indexing
3. **Caching Layers**: Multiple levels of caching
4. **CDN Integration**: Global content distribution

## Future Architecture Considerations

### Planned Enhancements

1. **Event Sourcing**: Audit trail and state reconstruction
2. **CQRS**: Separate read and write models
3. **GraphQL API**: Flexible data fetching
4. **Machine Learning Pipeline**: Enhanced AI capabilities
5. **Multi-tenancy**: SaaS platform scaling

### Technology Evolution

1. **Ruby 3.3+**: Performance improvements and new features
2. **Rails 8**: New features and optimizations
3. **Hotwire Native**: Mobile app development
4. **Progressive Web App**: Enhanced mobile experience
